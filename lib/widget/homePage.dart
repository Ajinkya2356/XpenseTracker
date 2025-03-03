import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add this import
import '../services/auth_service.dart'; // Add this import
import '../pages/dashboard_page.dart';
import '../pages/transactions_page.dart';
import '../pages/settings_page.dart';
import '../config/theme_config.dart';
import '../pages/notification_page.dart';
import '../pages/qr_scanner_page.dart';
import "../pages/login_page.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  String selectedMonth = 'March'; // Set default month

  void _onDestinationSelected(int index) {
    if (index == 1) {
      // QR Scanner
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const QRScannerPage(),
        ),
      );
    } else {
      // Update currentIndex for Home (0) and Expenses (2)
      setState(() {
        _currentIndex = index == 2 ? 1 : 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, auth, child) {
        if (!auth.isAuthenticated) {
          return const LoginPage();
        }

        final List<Widget> pages = [
          DashboardPage(
            onNavigate: (index) {
              if (index < 2) { // Ensure index is within bounds
                setState(() {
                  _currentIndex = index;
                });
              }
            },
          ),
          const TransactionsPage(),
        ];

        return Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ThemeConfig.appBarColor,
                    ThemeConfig.darkestBlue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            centerTitle: false,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Xpense',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_outlined),
                  iconSize: 24,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationPage(),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.account_circle_outlined),
                  iconSize: 24,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => auth.signOut(),
              ),
            ],
            elevation: 0,
          ),
          body: Container(
            color: ThemeConfig.backgroundColor, // Changed from gradient to solid color
            child: pages[_currentIndex],
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: ThemeConfig.surfaceColor,
                indicatorColor: ThemeConfig.primaryColor.withOpacity(0.1),
                labelTextStyle: WidgetStateProperty.all(
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            child: NavigationBar(
              height: 65,
              backgroundColor: ThemeConfig.surfaceColor,
              elevation: 0,
              indicatorColor: ThemeConfig.primaryColor.withOpacity(0.1),
              selectedIndex: _currentIndex == 1 ? 2 : _currentIndex, // Map internal index to UI index
              onDestinationSelected: _onDestinationSelected,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Container(
                    height: 75, // Increased from 45
                    width: 75,  // Increased from 45
                    margin: const EdgeInsets.only(top: 8), // Added margin to lift the button up
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue[300]!,
                          Colors.blue[500]!,
                          Colors.blue[700]!,
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 32, // Increased from 24
                    ),
                  ),
                  label: '', // Removed the 'Scan' label
                ),
                const NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: 'Expenses',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}