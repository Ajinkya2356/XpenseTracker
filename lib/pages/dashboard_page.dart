import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card with Total Expense
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
              colors: [ThemeConfig.darkestBlue, ThemeConfig.surfaceColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Expenses',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '₹24,500',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSimpleIndicator(
                      'Daily Avg',
                      '₹816',
                      Icons.calendar_today_outlined,
                    ),
                    _buildSimpleIndicator(
                      'This Week',
                      '₹5,712',
                      Icons.date_range_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Quick Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickAction('Add\nExpense', Icons.add_circle_outline, ThemeConfig.expenseRed),
                _buildQuickAction('View\nReport', Icons.assessment_outlined, ThemeConfig.categoryColors),
                _buildQuickAction('Set\nBudget', Icons.account_balance_wallet_outlined, Colors.amber),
                _buildQuickAction('Send\nMoney', Icons.send_outlined, Colors.green),
              ],
            ),
          ),

          // Spending by Category
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Spending by Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryCard('Food', '₹8,500', Icons.restaurant, Colors.orange),
                _buildCategoryCard('Shopping', '₹6,200', Icons.shopping_bag, Colors.blue),
                _buildCategoryCard('Transport', '₹4,800', Icons.directions_car, Colors.green),
                _buildCategoryCard('Bills', '₹5,000', Icons.receipt_long, Colors.purple),
              ],
            ),
          ),

          // Recent Transactions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ThemeConfig.categoryColors.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(index),
                      color: ThemeConfig.categoryColors,
                    ),
                  ),
                  title: Text(
                    _getCategoryName(index),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(_getDate(index)),
                  trailing: Text(
                    '-₹${_getAmount(index)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.expenseRed,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseIndicator(String label, String amount, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              amount,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction(String label, IconData icon, Color color) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String category, String amount, IconData icon, Color color) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            category,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(int index) {
    final icons = [
      Icons.fastfood,
      Icons.shopping_bag,
      Icons.local_taxi,
      Icons.movie,
      Icons.medical_services,
    ];
    return icons[index % icons.length];
  }

  String _getCategoryName(int index) {
    final categories = [
      'Food & Dining',
      'Shopping',
      'Transport',
      'Entertainment',
      'Healthcare',
    ];
    return categories[index % categories.length];
  }

  String _getDate(int index) {
    final dates = [
      'Today',
      'Yesterday',
      '22 Mar 2024',
      '21 Mar 2024',
      '20 Mar 2024',
    ];
    return dates[index];
  }

  String _getAmount(int index) {
    final amounts = [
      '2,500',
      '3,400',
      '1,200',
      '5,600',
      '2,800',
    ];
    return amounts[index];
  }

  Widget _buildSimpleIndicator(String label, String amount, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              amount,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
