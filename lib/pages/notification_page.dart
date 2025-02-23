import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class NotificationPage extends StatefulWidget {  // Changed to StatefulWidget
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationItem> notifications = List.from(_demoNotifications);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifications.isNotEmpty) // Only show if there are notifications
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: ThemeConfig.expenseRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.delete_outline_rounded, // Changed from clear_all to delete_outline_rounded
                      color: ThemeConfig.expenseRed,
                      size: 20, // Added size for better proportions
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Clear All',  // Changed from 'Clear' to 'Clear All'
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeConfig.expenseRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: ThemeConfig.surfaceColor,
                      title: const Text('Clear All Notifications?'),
                      content: const Text('This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              notifications.clear();
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('All notifications cleared'),
                                duration: const Duration(seconds: 2),
                                backgroundColor: ThemeConfig.surfaceColor,
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: ThemeConfig.expenseRed,
                          ),
                          child: const Text('Clear All'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      body: notifications.isEmpty 
          ? const Center(
              child: Text('No notifications'),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 16), // Added top padding
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  elevation: 0, // Removed shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
  NotificationItem(
    title: 'Large Transaction',
    message: 'Shopping expense of ₹5,600 recorded',
    time: '2 days ago',
    icon: Icons.shopping_bag,
    color: Colors.purple,
  ),
  NotificationItem(
    title: 'Bill Payment',
    message: 'Electricity bill paid successfully',
    time: '2 days ago',
    icon: Icons.bolt,
    color: Colors.green,
  ),
  NotificationItem(
    title: 'Category Limit',
    message: 'Food category spending near monthly limit',
    time: '3 days ago',
    icon: Icons.restaurant,
    color: Colors.deepOrange,
  ),
];
