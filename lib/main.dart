import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/expense_filters.dart';
import 'config/theme_config.dart';
import 'widget/homePage.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load();

  // Run the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseFilters()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xpense',
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.darkTheme,
      home: const HomePage(),
    );
  }
}
