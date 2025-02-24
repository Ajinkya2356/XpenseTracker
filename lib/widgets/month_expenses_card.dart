import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class MonthExpensesCard extends StatefulWidget {
  const MonthExpensesCard({super.key});

  @override
  State<MonthExpensesCard> createState() => _MonthExpensesCardState();
}

class _MonthExpensesCardState extends State<MonthExpensesCard> {
  bool isExpanded = false;
  
  // Dummy data - Replace with your actual data model
  final List<Map<String, dynamic>> monthlyExpenses = [
    {'month': 'March 2024', 'amount': 2500, 'change': 5.2},
    {'month': 'February 2024', 'amount': 2300, 'change': -2.1},
    {'month': 'January 2024', 'amount': 2400, 'change': 1.5},
    {'month': 'December 2023', 'amount': 2200, 'change': -3.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Current Month Section
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'March 2024',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: ThemeConfig.primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹2,500',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ThemeConfig.primaryColor,
                            ),
                          ),
                          const Text(
                            'Total Expenses',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.arrow_upward,
                              size: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '5.2%',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Past Months Section
          if (isExpanded) ...[
            const Divider(height: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: monthlyExpenses.length - 1, // Skip current month
              itemBuilder: (context, index) {
                final expense = monthlyExpenses[index + 1];
                final isPositiveChange = expense['change'] >= 0;
                
                return ListTile(
                  title: Text(
                    expense['month'],
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '₹${expense['amount']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (isPositiveChange ? Colors.green : Colors.red)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${isPositiveChange ? '+' : ''}${expense['change']}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: isPositiveChange ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
