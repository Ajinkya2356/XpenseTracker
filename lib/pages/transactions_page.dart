import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search and Filter Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: ThemeConfig.surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Search expenses',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ThemeConfig.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.filter_list),
                ),
              ],
            ),
          ),

          // Transactions List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 20,
              itemBuilder: (context, index) {
                final expense = _getExpense(index);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Reduced padding
                    leading: Container(
                      padding: const EdgeInsets.all(8), // Reduced padding
                      decoration: BoxDecoration(
                        color: expense.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8), // Reduced radius
                      ),
                      child: Icon(expense.icon, color: expense.color, size: 22), // Slightly larger icon
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          expense.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16, // Increased from 15
                          ),
                        ),
                        Text(
                          '₹${expense.amount}',
                          style: TextStyle(
                            color: expense.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 18, // Increased from 16
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4), // Reduced top padding
                      child: Text(
                        _getDate(index),
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13, // Increased from 12
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

  Expense _getExpense(int index) {
    final expenses = [
      Expense(
        'Groceries',
        Icons.shopping_cart,
        '2,450',
        const Color(0xFF4CAF50),
      ),
      Expense(
        'Restaurant',
        Icons.restaurant,
        '1,800',
        const Color(0xFFF44336),
      ),
      Expense(
        'Uber',
        Icons.directions_car,
        '3,200',
        const Color(0xFF2196F3),
      ),
      Expense(
        'Shopping',
        Icons.shopping_bag,
        '5,600',
        const Color(0xFF9C27B0),
      ),
      Expense(
        'Electricity',
        Icons.electric_bolt,
        '4,200',
        const Color(0xFFFF9800),
      ),
      Expense(
        'Medicine',
        Icons.medical_services,
        '2,800',
        const Color(0xFF00BCD4),
      ),
    ];
    return expenses[index % expenses.length];
  }

  String _getDate(int index) {
    final today = DateTime.now();
    final date = today.subtract(Duration(days: index));
    if (index == 0) return 'Today';
    if (index == 1) return 'Yesterday';
    return '${date.day} ${_getMonth(date.month)}';
  }

  String _getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

class Expense {
  final String name;
  final IconData icon;
  final String amount;
  final Color color;

  Expense(this.name, this.icon, this.amount, this.color);
}
