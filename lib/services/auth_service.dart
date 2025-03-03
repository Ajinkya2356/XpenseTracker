import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _userEmail;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get userEmail => _userEmail;

  final SupabaseClient _supabase = Supabase.instance.client;
  late final GoogleSignIn _googleSignIn;

  /// Initialize Supabase (Call this in `main.dart`)
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'),
      anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    );
  }

  AuthService() {
    _googleSignIn = GoogleSignIn(
      serverClientId: dotenv.get('GOOGLE_WEB_CLIENT_ID'),
      scopes: [
        'email',
        'profile',
        'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ],
      signInOption: SignInOption.standard,
    );
    // Check if user is already authenticated
    _checkCurrentSession();
  }

  void _checkCurrentSession() {
    final session = _supabase.auth.currentSession;
    _isAuthenticated = session != null;
    _userEmail = _supabase.auth.currentUser?.email;
    notifyListeners();
  }

  /// Sign in with Google on Web (One Tap)
  Future<void> signInWithGoogleWeb() async {
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: dotenv.get('SUPABASE_REDIRECT_URL'),
    );
  }

  /// Sign in with Google on Android
  Future<void> signInWithGoogleAndroid() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Force account chooser dialog by signing out first
      await _googleSignIn.signOut();
      
      // Attempt to sign in silently first
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      googleUser ??= await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google Sign In was canceled by user');
      }

      // Retry token retrieval up to 3 times
      GoogleSignInAuthentication? googleAuth;
      int retryCount = 0;
      while (retryCount < 3) {
        try {
          googleAuth = await googleUser.authentication;
          if (googleAuth.idToken != null && googleAuth.accessToken != null) {
            break;
          }
          retryCount++;
          await Future.delayed(Duration(seconds: 1));
        } catch (e) {
          debugPrint('Token retrieval attempt $retryCount failed: $e');
          retryCount++;
          if (retryCount == 3) rethrow;
        }
      }

      if (googleAuth == null || googleAuth.idToken == null || googleAuth.accessToken == null) {
        throw Exception('''
          Failed to get Google auth tokens.
          Auth: ${googleAuth != null}
          ID Token: ${googleAuth?.idToken != null}
          Access Token: ${googleAuth?.accessToken != null}
        ''');
      }

      debugPrint('Successfully retrieved auth tokens');

      // Sign in with Supabase using the Google token
      final AuthResponse res = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );

      if (res.session == null) {
        throw Exception('Failed to create Supabase session');
      }

      // Get user details
      debugPrint('Successfully signed in: ${googleUser.email}');
      debugPrint('Display Name: ${googleUser.displayName}');
      debugPrint('Photo URL: ${googleUser.photoUrl}');

      _isAuthenticated = true;
      _userEmail = googleUser.email;

      // Store user details after successful sign-in
      await _storeUserDetails(googleUser);
    } catch (e) {
      debugPrint('Detailed error during sign in: $e');
      _isAuthenticated = false;
      _userEmail = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _storeUserDetails(GoogleSignInAccount googleUser) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        print("User is not logged in");
        return;
      }

      // Store user details in Supabase
      await _supabase.from('user_profiles').upsert({
        'id': currentUser.id,  // Use the `id` from `auth.users` for the foreign key
        'email': googleUser.email,
        'full_name': googleUser.displayName,
        'profile_image_url': googleUser.photoUrl,
        'last_login': DateTime.now().toIso8601String()
      });

      debugPrint('User details stored successfully');
    } catch (e) {
      debugPrint('Error storing user details: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Sign out from both Google and Supabase
      await _googleSignIn.signOut();
      await _supabase.auth.signOut();
      _isAuthenticated = false;
      _userEmail = null;
    } catch (e) {
      debugPrint('Error signing out: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Listen for auth state changes
  void listenAuthChanges(Function(AuthState) callback) {
    _supabase.auth.onAuthStateChange.listen((event) {
      _isAuthenticated = event.session != null;
      _userEmail = event.session?.user.email;
      notifyListeners();
      callback(event);
    });
  }

  /// Get current user
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }
}
