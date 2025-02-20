import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monthly Budget Progress
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Monthly Budget',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeConfig.expenseRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '91.6% Used',
                          style: TextStyle(
                            color: ThemeConfig.expenseRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '₹45,800 / ₹50,000',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: 0.916,
                      backgroundColor: ThemeConfig.expenseRed.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(ThemeConfig.expenseRed),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Expense Trends
          const Text(
            'Expense Trends',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.5,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildTrendsChart(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Category Analysis
          const Text(
            'Category Analysis',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildCategoryAnalysis(),
        ],
      ),
    );
  }

  Widget _buildTrendsChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Last 7 Days',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              7,
              (index) => _buildBar(
                height: [0.4, 0.6, 0.3, 0.8, 0.5, 0.7, 0.4][index],
                label: ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                amount: ['816', '1.2k', '645', '1.5k', '980', '1.3k', '750'][index],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBar({
    required double height,
    required String label,
    required String amount,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '₹$amount',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 30,
          height: 150 * height,
          decoration: BoxDecoration(
            color: ThemeConfig.primaryColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildCategoryAnalysis() {
    final categories = [
      {'name': 'Shopping', 'amount': '₹15,200', 'percent': 0.35, 'icon': Icons.shopping_bag},
      {'name': 'Food', 'amount': '₹12,800', 'percent': 0.28, 'icon': Icons.restaurant},
      {'name': 'Transport', 'amount': '₹8,400', 'percent': 0.18, 'icon': Icons.directions_car},
      {'name': 'Bills', 'amount': '₹6,900', 'percent': 0.15, 'icon': Icons.receipt},
    ];

    return Column(
      children: categories.map((category) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(category['icon'] as IconData),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    category['amount'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: category['percent'] as double,
                  backgroundColor: ThemeConfig.surfaceColor,
                  valueColor: AlwaysStoppedAnimation<Color>(ThemeConfig.primaryColor),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }
}
