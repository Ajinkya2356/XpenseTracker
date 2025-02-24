import 'package:flutter/material.dart';
import '../pages/dashboard_page.dart';
import '../pages/transactions_page.dart';
import '../pages/settings_page.dart';
import '../config/theme_config.dart';
import '../pages/notification_page.dart';
import '../pages/settings_page.dart';
import '../pages/qr_scanner_page.dart';
import '../pages/analytics_page.dart';  // Add this import

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    const DashboardPage(),
    const TransactionsPage(),
    const SizedBox(), // Placeholder for QR Scanner
  ];

  @override
  Widget build(BuildContext context) {
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
      body: pages[_currentIndex == 2 ? 0 : _currentIndex], // Skip index 2 (QR Scanner)
      bottomNavigationBar: BottomAppBar(
        height: 75, // Increased height to accommodate larger button
        padding: EdgeInsets.zero,
        color: ThemeConfig.surfaceColor,
        child: Row(
          children: [
            // Left side items (Home)
            Expanded(
              child: Center(
                child: _buildNavItem(0, Icons.dashboard_outlined, Icons.dashboard, 'Home'),
              ),
            ),
            
            // Center QR Scanner button
            Container(
              width: 75,  // Increased from 65
              height: 75, // Increased from 65
              margin: const EdgeInsets.only(bottom: 15), // Increased from 10
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
                boxShadow: [  // Added subtle shadow
                  BoxShadow(
                    color: ThemeConfig.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QRScannerPage(),
                      ),
                    );
                  },
                  customBorder: const CircleBorder(),
                  child: const Icon(
                    Icons.qr_code_scanner,
                    size: 40, // Increased from 35
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            // Right side items (Expenses)
            Expanded(
              child: Center(
                child: _buildNavItem(1, Icons.receipt_long_outlined, Icons.receipt_long, 'Expenses'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;
    
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? ThemeConfig.primaryColor : Colors.grey,
              size: 24,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? ThemeConfig.primaryColor : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}