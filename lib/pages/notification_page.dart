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
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: ThemeConfig.backgroundColor,
      body: notifications.isEmpty 
          ? _buildEmptyState()
          : Column(
              children: [
                // Today's Summary
                if (notifications.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2C3E50),  // Rich dark blue
                          const Color(0xFF1A237E).withOpacity(0.95), // Deep indigo
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ThemeConfig.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: ThemeConfig.primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.notifications_active,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Today's Updates",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${notifications.length} new notifications',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _showClearConfirmationDialog(context),
                          icon: Icon(
                            Icons.delete_outline_rounded,  // Changed icon
                            size: 20,
                            color: Colors.white.withOpacity(0.95),  // Slightly transparent white
                          ),
                          label: Text(
                            'Clear All',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              color: Colors.white.withOpacity(0.95),  // Matching icon color
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFFE53935),  // Slightly darker red
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Notifications List with Animation
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.easeInOut,
                        transform: Matrix4.translationValues(0, 0, 0),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: notification.color.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      notification.icon,
                                      color: notification.color,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          notification.message,
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 14,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              notification.time,
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmationDialog(BuildContext context) {
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
