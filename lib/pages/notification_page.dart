import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              // Clear all notifications
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _demoNotifications.length,
        itemBuilder: (context, index) {
          final notification = _demoNotifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: notification.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(notification.icon, color: notification.color),
              ),
              title: Text(notification.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.message),
                  const SizedBox(height: 4),
                  Text(
                    notification.time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color color;

  const NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
  });
}

final _demoNotifications = [
  NotificationItem(
    title: 'Budget Alert',
    message: 'You\'ve reached 80% of your monthly budget',
    time: '2 hours ago',
    icon: Icons.warning_amber_rounded,
    color: Colors.orange,
  ),
  NotificationItem(
    title: 'New Feature',
    message: 'Try our new budget planning tool',
    time: '5 hours ago',
    icon: Icons.new_releases,
    color: Colors.blue,
  ),
  NotificationItem(
    title: 'Expense Due',
    message: 'Reminder: Utility bill payment due tomorrow',
    time: '1 day ago',
    icon: Icons.event,
    color: ThemeConfig.expenseRed,
  ),
];
