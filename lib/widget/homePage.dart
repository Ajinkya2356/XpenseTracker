import 'package:flutter/material.dart';
import '../pages/dashboard_page.dart';
import '../pages/transactions_page.dart';
import '../pages/settings_page.dart';
import '../config/theme_config.dart';
import '../pages/notification_page.dart';
import '../pages/settings_page.dart';
import '../pages/qr_scanner_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onDestinationSelected(int index) {
    // Fixed navigation logic
    if (index == 0) {
      setState(() {
        _currentIndex = 0;
      });
    } else if (index == 1) {
      setState(() {
        _currentIndex = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        ],
        elevation: 0,
      ),
      body: Container(
        color: ThemeConfig.backgroundColor, // Changed from gradient to solid color
        child: pages[_currentIndex],
      ),
      floatingActionButton: Container(
        height: 65,
        width: 65,
        margin: const EdgeInsets.only(top: 25), // Adjusted top margin
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.lightBlueAccent,
              ThemeConfig.primaryColor,
              ThemeConfig.darkBlue,
            ],
          ),
          shape: BoxShape.circle,
          // Removed boxShadow property
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QRScannerPage(),
              ),
            );
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: const Icon(
            Icons.qr_code_scanner,
            size: 40, // Increased icon size
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
        child: BottomAppBar(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 8), // Added padding
          color: ThemeConfig.surfaceColor,
          shape: const CircularNotchedRectangle(), // Added notch
          notchMargin: 8, // Increased notch margin for more space
          clipBehavior: Clip.antiAlias, // Added smooth clipping
          child: NavigationBar(
            height: 65,
            backgroundColor: Colors.transparent, // Made transparent to show BottomAppBar
            elevation: 0, // Removed elevation
            indicatorColor: ThemeConfig.primaryColor.withOpacity(0.1),
            selectedIndex: _currentIndex,
            onDestinationSelected: _onDestinationSelected,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: 'Expenses',
              ),
            ],
          ),
        ),
      ),
    );
  }
}