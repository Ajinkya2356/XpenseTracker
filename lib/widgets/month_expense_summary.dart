import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class MonthExpenseSummary extends StatefulWidget {
  const MonthExpenseSummary({super.key});

  @override
  State<MonthExpenseSummary> createState() => _MonthExpenseSummaryState();
}

class _MonthExpenseSummaryState extends State<MonthExpenseSummary> {
  bool isExpanded = false;
  int selectedMonthIndex = 0;

  final List<Map<String, dynamic>> monthlyData = [
    {
      'month': 'March 2024',
      'amount': '45,800',
      'dailyAvg': '1,477',
      'highest': '12,500',
      'change': 8.4,
    },
    {
      'month': 'February 2024',
      'amount': '38,600',
      'dailyAvg': '1,379',
      'highest': '8,900',
      'change': -5.2,
    },
    {
      'month': 'January 2024',
      'amount': '42,300',
      'dailyAvg': '1,365',
      'highest': '10,200',
      'change': -12.1,
    },
    {
      'month': 'December 2023',
      'amount': '36,900',
      'dailyAvg': '1,190',
      'highest': '7,800',
      'change': 3.2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentMonth = monthlyData[selectedMonthIndex];
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Current Month Header
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentMonth['month'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Total Expenses',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '₹${currentMonth['amount']}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ThemeConfig.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStat('Daily Avg', '₹${currentMonth['dailyAvg']}'),
                      _buildDivider(),
                      _buildStat('Highest', '₹${currentMonth['highest']}'),
                      _buildDivider(),
                      _buildExpandButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Previous Months
          if (isExpanded) ...[
            const Divider(height: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: monthlyData.length,
              itemBuilder: (context, index) {
                if (index == selectedMonthIndex) return const SizedBox.shrink();
                
                final month = monthlyData[index];
                return ListTile(
                  selected: selectedMonthIndex == index,
                  onTap: () => setState(() {
                    selectedMonthIndex = index;
                    isExpanded = false;
                  }),
                  title: Text(month['month']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '₹${month['amount']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildChangeIndicator(month['change']),
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

  Widget _buildExpandButton() {
    return Row(
      children: [
        Icon(
          isExpanded ? Icons.expand_less : Icons.expand_more,
          color: ThemeConfig.primaryColor,
        ),
        Text(
          isExpanded ? 'Less' : 'More',
          style: TextStyle(
            color: ThemeConfig.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 24,
      width: 1,
      color: Colors.grey.withOpacity(0.2),
    );
  }

  Widget _buildChangeIndicator(double change) {
    final isPositive = change >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${isPositive ? '+' : ''}$change%',
        style: TextStyle(
          fontSize: 12,
          color: isPositive ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
