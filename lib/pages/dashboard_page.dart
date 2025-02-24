import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class DashboardPage extends StatefulWidget {  // Changed to StatefulWidget
  final Function(int)? onNavigate;  // Add this line
  const DashboardPage({this.onNavigate, super.key});  // Update constructor

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<Map<String, dynamic>> categories = [
    {'name': 'Food', 'amount': '₹8,500', 'icon': Icons.restaurant, 'color': Colors.orange},
    {'name': 'Shopping', 'amount': '₹6,200', 'icon': Icons.shopping_bag, 'color': Colors.blue},
    {'name': 'Transport', 'amount': '₹4,800', 'icon': Icons.directions_car, 'color': Colors.green},
    {'name': 'Bills', 'amount': '₹5,000', 'icon': Icons.receipt_long, 'color': Colors.purple},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.98, // Increased from 0.97 for better card spacing
      initialPage: _currentPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Add this list of gradients for each month
  final List<List<Color>> monthGradients = [
    [const Color(0xFF1A237E), const Color(0xFF0D47A1)], // January - Deep Blue
    [const Color(0xFF880E4F), const Color(0xFFC2185B)], // February - Pink
    [const Color(0xFF1B5E20), const Color(0xFF2E7D32)], // March - Green
    [const Color(0xFF311B92), const Color(0xFF4527A0)], // April - Deep Purple
    [const Color(0xFFBF360C), const Color(0xFFE64A19)], // May - Deep Orange
    [const Color(0xFF0277BD), const Color(0xFF0288D1)], // June - Light Blue
    [const Color(0xFF004D40), const Color(0xFF00695C)], // July - Teal
    [const Color(0xFF6A1B9A), const Color(0xFF7B1FA2)], // August - Purple
    [const Color(0xFF1565C0), const Color(0xFF1976D2)], // September - Blue
    [const Color(0xFF827717), const Color(0xFF9E9D24)], // October - Lime
    [const Color(0xFF4A148C), const Color(0xFF6A1B9A)], // November - Purple
    [const Color(0xFF263238), const Color(0xFF37474F)], // December - Blue Grey
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monthly Summary Section
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'March 2024',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total Expenses',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '₹45,800',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ThemeConfig.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('Daily Avg', '₹1,477'),
                      Container(
                        height: 24,
                        width: 1,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      _buildStat('Highest', '₹12,500'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Category Spending Title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16), // Increased top padding
            child: Text(
              'Spending by Category',
              style: TextStyle(
                fontSize: 20, // Increased from 16
                fontWeight: FontWeight.bold,
                color: Colors.grey[200],
              ),
            ),
          ),
          
          // Category Spending Cards
          _buildCategorySpending(),
          
          // Recent Transactions Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16), // Increased top padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 20, // Increased from 16
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[200],
                  ),
                ),
                TextButton(
                  onPressed: () => widget.onNavigate?.call(1),
                  child: const Text(
                    'See All',
                    style: TextStyle(fontSize: 16), // Increased from default
                  ),
                ),
              ],
            ),
          ),

          // ...rest of the existing code...
        ],
      ),
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

  Widget _buildCategorySpending() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            width: 130,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: category['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: category['color'].withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(category['icon'], color: category['color']),
                const Spacer(),
                Text(
                  category['name'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    category['amount'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: category['color'],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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

  Widget _buildMonthCard(int index, double screenWidth) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    final monthlyData = [
      {'total': '45,800', 'daily': '1,477', 'highest': '12,500'},
      {'total': '38,600', 'daily': '1,379', 'highest': '8,900'},
      {'total': '42,300', 'daily': '1,365', 'highest': '10,200'},
    ][index % 3];

    // Calculate a lighter version of darkColor
    final lighterDarkColor = HSLColor.fromColor(ThemeConfig.darkColor)
        .withLightness(0.1) // Increase lightness from ~0.05 to 0.2
        .toColor();

    return Container(
      width: screenWidth * 0.96,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        elevation: _currentPage == index ? 8 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                monthGradients[index][0].withOpacity(0.8),
                Color.lerp(monthGradients[index][1], lighterDarkColor, 0.5) ?? lighterDarkColor,
                ThemeConfig.darkColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.5, 1.0], // Adjusted stops for smoother transition
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: monthGradients[index][0].withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                right: -50,
                top: -50,
                child: Icon(
                  Icons.donut_large,
                  size: 200,
                  color: monthGradients[index][0].withOpacity(0.05),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Month and Year
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              months[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: monthGradients[index][0].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: monthGradients[index][0].withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Text(
                                '2024',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        
                        // Total Amount
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '₹',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                            Text(
                              monthlyData['total']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40, // Reduced from 42
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16), // Reduced from 20
                        
                        // Stats
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Reduced vertical padding
                          decoration: BoxDecoration(
                            color: ThemeConfig.darkColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: monthGradients[index][0].withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                'DAILY AVG',
                                '₹${monthlyData['daily']}',
                                Icons.calendar_today_outlined,
                              ),
                              Container(
                                width: 1,
                                height: 25, // Reduced from 30
                                color: Colors.white.withOpacity(0.2),
                              ),
                              _buildStatItem(
                                'HIGHEST',
                                '₹${monthlyData['highest']}',
                                Icons.show_chart,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 12),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Expense _getExpense(int index) {
    final expenses = [
      Expense('Groceries', Icons.shopping_cart, '2,450', const Color(0xFF4CAF50)),
      Expense('Restaurant', Icons.restaurant, '1,800', const Color(0xFFF44336)),
      Expense('Uber', Icons.directions_car, '3,200', const Color(0xFF2196F3)),
      Expense('Shopping', Icons.shopping_bag, '5,600', const Color(0xFF9C27B0)),
      Expense('Electricity', Icons.electric_bolt, '4,200', const Color(0xFFFF9800)),
    ];
    return expenses[index % expenses.length];
  }

  Widget _buildPaymentMethod(String asset, String name) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ThemeConfig.surfaceColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(
            asset,
            width: 48,
            height: 48,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
          ),
        ),
      ],
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

  String _getPaymentName(int index) {
    final names = [
      'GPay',
      'PhonePe',
      'Paytm',
    ];
    return names[index % names.length];
  }
}

class Expense {
  final String name;
  final IconData icon;
  final String amount;
  final Color color;

  Expense(this.name, this.icon, this.amount, this.color);
}