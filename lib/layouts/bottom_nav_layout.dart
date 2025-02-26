import 'package:flutter/material.dart';
import '../config/theme_config.dart';
import '../pages/transactions_page.dart';
// ...other imports

class BottomNavLayout extends StatefulWidget {
  const BottomNavLayout({super.key});

  @override
  State<BottomNavLayout> createState() => _BottomNavLayoutState();
}

class _BottomNavLayoutState extends State<BottomNavLayout> {
  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Add this to make body extend behind bottom nav
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          // ... your other pages
          TransactionsPage(),
          // ... your other pages
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            // QR Scanner navigation logic
          },
          backgroundColor: ThemeConfig.primaryColor,
          child: const Icon(Icons.qr_code_scanner),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8, // Add notch margin
        shape: const CircularNotchedRectangle(), // Add notch shape
        color: ThemeConfig.surfaceColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // First half of items
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Your bottom nav items for left side
                ],
              ),
            ),
            
            // Gap for FAB
            const SizedBox(width: 80),
            
            // Second half of items
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Your bottom nav items for right side
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
