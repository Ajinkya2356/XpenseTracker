import 'package:flutter/material.dart';
import '../pages/notification_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLeading;

  const CustomAppBar({
    super.key,
    this.title,
    this.showLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showLeading ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ) : null,
      title: Text(title ?? 'Xpense'),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            print('TEST 1: Icon clicked');  // Basic print
            debugPrint('TEST 2: Debug print test');  // Debug print
            
            // Show visual feedback
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notification icon clicked!'),
                duration: Duration(seconds: 1),
              ),
            );
            
            // Navigate after showing snackbar
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  print('TEST 3: Building NotificationPage');  // Print in builder
                  return const NotificationPage();
                },
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () {

          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
