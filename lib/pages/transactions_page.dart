import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 20,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final expense = _getExpense(index);
          final paymentIcon = _getPaymentIcon(index);
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Category Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: expense.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(expense.icon, color: expense.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  // Title and Date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getDate(index),
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Amount and Payment Method
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${expense.amount}',
                        style: TextStyle(
                          color: expense.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 22,
                        width: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: ThemeConfig.surfaceColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Image.asset(
                          paymentIcon,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getPaymentIcon(int index) {
    final icons = [
      'assets/gpay.png',
      'assets/phonepe.png',
      'assets/paytm.png',
    ];
    return icons[index % icons.length];
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
