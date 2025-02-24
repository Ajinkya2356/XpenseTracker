import 'package:flutter/material.dart';
import 'custom_bottom_nav.dart';

class BottomNavScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final Function(int) onNavigate;
  final PreferredSizeWidget? appBar;

  const BottomNavScaffold({
    required this.body,
    required this.currentIndex,
    required this.onNavigate,
    this.appBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        onTap: onNavigate,
      ),
    );
  }
}
