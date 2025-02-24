import 'package:flutter/material.dart';
import '../config/theme_config.dart';
import '../pages/qr_scanner_page.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeConfig.surfaceColor,
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 2) {
            // Open QR Scanner when middle button is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QRScannerPage()),
            );
          } else {
            onTap(index);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: ThemeConfig.primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Expenses',
          ),
          // QR Scanner Button in the middle
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ThemeConfig.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
              ),
            ),
            label: 'Scan',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
