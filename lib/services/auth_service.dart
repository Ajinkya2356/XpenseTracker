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
      scopes: [
        'email',
        'profile',
      ],
    );
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
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Log token for debugging
        debugPrint('Access Token: ${googleAuth.accessToken}');
        debugPrint('ID Token: ${googleAuth.idToken}');

        // Get user details
        debugPrint('Successfully signed in: ${googleUser.email}');
        debugPrint('Display Name: ${googleUser.displayName}');
        debugPrint('Photo URL: ${googleUser.photoUrl}');

        _isAuthenticated = true;
        _userEmail = googleUser.email;

        await _storeUserDetails(googleUser);
      }
    } catch (e) {
      debugPrint('Error signing in: $e');
      _isAuthenticated = false;
      _userEmail = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _storeUserDetails(GoogleSignInAccount user) async {
    try {
      // Store user details in Supabase or local storage
      await _supabase.from('users').upsert({
        'email': user.email,
        'full_name': user.displayName,
        'profile_image_url': user.photoUrl,
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
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      _isAuthenticated = false;
      _userEmail = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Listen for auth state changes
  void listenAuthChanges(Function(Session?) callback) {
    _supabase.auth.onAuthStateChange.listen((event) {
      callback(event.session);
    });
  }

  /// Get current user
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }
}
