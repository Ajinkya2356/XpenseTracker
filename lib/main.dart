import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/theme_config.dart';
import 'services/auth_service.dart';
import 'widget/auth_wrapper.dart';
import 'services/user_settings_service.dart';

void main() async {
  await dotenv.load();g.ensureInitialized();
  await AuthService.initialize();
  await AuthService.initialize();
  runApp(
    MultiProvider(aredPreferences
      providers: [ait SharedPreferences.getInstance();
  final localStorageService = LocalStorageService(prefs);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(
          create: (context) => UserSettings(
            Supabase.instance.client,
            localStorageService,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
  child: const AuthWrapper(),
class MyApp extends StatelessWidget {   ),
  const MyApp({super.key});   );
  }










}  }    );      home: const AuthWrapper(),      theme: ThemeConfig.darkTheme,      title: 'Xpense',    return MaterialApp(  Widget build(BuildContext context) {  @override}

class LifecycleWatcher extends StatefulWidget {
  final Widget child;
  
  const LifecycleWatcher({required this.child, super.key});
  
  @override
  State<LifecycleWatcher> createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);











}  Widget build(BuildContext context) => widget.child;  @override  }    }      userSettings.syncToDatabase();      final userSettings = Provider.of<UserSettings>(context, listen: false);      // Sync data when app goes to background





    if (state == AppLifecycleState.paused) {  void didChangeAppLifecycleState(AppLifecycleState state) {  @override  }    super.dispose();    WidgetsBinding.instance.removeObserver(this);  }

  @override
  void dispose() {