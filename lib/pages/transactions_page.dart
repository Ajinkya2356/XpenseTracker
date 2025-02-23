import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  bool _isFilterChanged = false;
  RangeValues _expenseRange = const RangeValues(0, 10000);
  RangeValues _currentRange = const RangeValues(0, 10000);
  List<String> selectedCategories = [];
  List<String> selectedPaymentMethods = [];
  List<Expense> filteredExpenses = [];
  List<Expense> allExpenses = [];

  @override
  void initState() {
    super.initState();
    allExpenses = [
      Expense('Groceries', Icons.shopping_cart, 2450, const Color(0xFF4CAF50), 'Google Pay'),
      Expense('Restaurant', Icons.restaurant, 1800, const Color(0xFFF44336), 'PhonePe'),
      Expense('Uber', Icons.directions_car, 3200, const Color(0xFF2196F3), 'Paytm'),
      Expense('Shopping', Icons.shopping_bag, 5600, const Color(0xFF9C27B0), 'Google Pay'),
      Expense('Electricity', Icons.electric_bolt, 4200, const Color(0xFFFF9800), 'PhonePe'),
      Expense('Medicine', Icons.medical_services, 2800, const Color(0xFF00BCD4), 'Paytm'),
      // Adding more transactions
      Expense('Movie Tickets', Icons.movie, 1200, const Color(0xFF3F51B5), 'Google Pay'),
      Expense('Gas Bill', Icons.local_gas_station, 950, const Color(0xFF795548), 'PhonePe'),
      Expense('Internet Bill', Icons.wifi, 1499, const Color(0xFF607D8B), 'Paytm'),
      Expense('Gym Membership', Icons.fitness_center, 2999, const Color(0xFF9C27B0), 'Google Pay'),
      Expense('Office Lunch', Icons.lunch_dining, 450, const Color(0xFFE91E63), 'PhonePe'),
      Expense('Books', Icons.book, 899, const Color(0xFF009688), 'Paytm'),
      Expense('Mobile Recharge', Icons.phone_android, 749, const Color(0xFF673AB7), 'Google Pay'),
      Expense('Coffee Shop', Icons.coffee, 280, const Color(0xFF795548), 'PhonePe'),
      Expense('Supermarket', Icons.local_grocery_store, 3450, const Color(0xFF4CAF50), 'Paytm'),
    ];
    filteredExpenses = List.from(allExpenses);
  }

  final List<Map<String, dynamic>> categories = [
    {'name': 'Food', 'icon': Icons.restaurant, 'color': Colors.orange},
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': Colors.blue},
    {'name': 'Transport', 'icon': Icons.directions_car, 'color': Colors.green},
    {'name': 'Bills', 'icon': Icons.receipt, 'color': Colors.purple},
    {'name': 'Health', 'icon': Icons.medical_services, 'color': Colors.red},
    {'name': 'Entertainment', 'icon': Icons.movie, 'color': Colors.pink},
  ];

  final List<Map<String, dynamic>> paymentMethods = [
    {'name': 'Google Pay', 'asset': 'assets/gpay.png'},
    {'name': 'PhonePe', 'asset': 'assets/phonepe.png'},
    {'name': 'Paytm', 'asset': 'assets/paytm.png'},
  ];

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: ThemeConfig.darkColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(
            color: ThemeConfig.primaryColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Fancy Header with subtle gradient
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ThemeConfig.darkColor.withOpacity(0.9),
                    ThemeConfig.darkColor,
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: ThemeConfig.primaryColor.withOpacity(0.2),
                  ),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ThemeConfig.primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Transactions',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ThemeConfig.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ThemeConfig.primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          '${selectedCategories.length + selectedPaymentMethods.length} Selected',
                          style: TextStyle(
                            color: ThemeConfig.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Filter Content
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    // Tab Bar
                    TabBar(
                      indicatorColor: ThemeConfig.primaryColor,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: ThemeConfig.primaryColor,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(text: 'Payment Mode'),
                        Tab(text: 'Categories'),
                        Tab(text: 'Amount'),
                      ],
                    ),
                    
                    // Tab Content
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Payment Methods Tab
                          _buildPaymentMethodsTab(),
                          
                          // Categories Tab
                          _buildCategoriesTab(),
                          
                          // Amount Range Tab
                          _buildAmountRangeTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            _buildFilterActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: paymentMethods.length,
      itemBuilder: (context, index) {
        final method = paymentMethods[index];
        final isSelected = selectedPaymentMethods.contains(method['name']);
        
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedPaymentMethods.remove(method['name']);
                } else {
                  selectedPaymentMethods.add(method['name']);
                }
                _isFilterChanged = true;
              });
            },
            splashColor: ThemeConfig.primaryColor.withOpacity(0.1),
            highlightColor: ThemeConfig.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSelected ? [
                    ThemeConfig.primaryColor.withOpacity(0.3),
                    ThemeConfig.primaryColor.withOpacity(0.1),
                  ] : [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? ThemeConfig.primaryColor
                      : Colors.white.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    method['asset'],
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    method['name'],
                    style: TextStyle(
                      color: isSelected
                          ? ThemeConfig.primaryColor
                          : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = selectedCategories.contains(category['name']);
        
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedCategories.remove(category['name']);
                } else {
                  selectedCategories.add(category['name']);
                }
                _isFilterChanged = true;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSelected ? [
                    category['color'].withOpacity(0.3),
                    category['color'].withOpacity(0.1),
                  ] : [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? category['color']
                      : Colors.white.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category['icon'],
                    color: isSelected
                        ? category['color']
                        : Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['name'],
                    style: TextStyle(
                      color: isSelected
                          ? category['color']
                          : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAmountRangeTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Amount Range',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAmountDisplay('Min', _expenseRange.start),
              _buildAmountDisplay('Max', _expenseRange.end),
            ],
          ),
          const SizedBox(height: 24),
          RangeSlider(
            values: _expenseRange,
            min: 0,
            max: 10000,
            divisions: 100,
            activeColor: ThemeConfig.primaryColor,
            inactiveColor: Colors.white.withOpacity(0.2),
            labels: RangeLabels(
              '₹${_expenseRange.start.round()}',
              '₹${_expenseRange.end.round()}',
            ),
            onChanged: (values) {
              setState(() {
                _expenseRange = values;
                _isFilterChanged = true;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAmountDisplay(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '₹${value.round()}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _applyFilters() {
    setState(() {
      filteredExpenses = allExpenses.where((expense) {
        bool matchesCategory = selectedCategories.isEmpty || 
            selectedCategories.contains(expense.name);
        
        bool matchesPaymentMethod = selectedPaymentMethods.isEmpty || 
            selectedPaymentMethods.contains(expense.paymentMethod);
        
        bool matchesAmount = expense.amountValue >= _currentRange.start && 
            expense.amountValue <= _currentRange.end;

        return matchesCategory && matchesPaymentMethod && matchesAmount;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      selectedCategories.clear();
      selectedPaymentMethods.clear();
      _currentRange = const RangeValues(0, 10000);
      _expenseRange = _currentRange;
      _isFilterChanged = false;
      filteredExpenses = List.from(allExpenses);
    });
  }

  Widget _buildFilterActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ThemeConfig.darkColor,
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                _resetFilters();
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Reset All'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FilledButton(
              onPressed: _isFilterChanged ? () {
                setState(() {
                  _currentRange = _expenseRange;
                  _applyFilters();
                });
                Navigator.pop(context);
              } : null,
              style: FilledButton.styleFrom(
                backgroundColor: _isFilterChanged 
                    ? ThemeConfig.primaryColor 
                    : ThemeConfig.primaryColor.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: TextStyle(
                  color: _isFilterChanged ? Colors.white : Colors.white60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(  // Changed back to Column from Stack
      children: [
        // Search bar
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
              GestureDetector(
                onTap: _showFilterSheet,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ThemeConfig.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.filter_list),
                ),
              ),
            ],
          ),
        ),

        // Transactions List
        Expanded(
          child: filteredExpenses.isEmpty
              ? Center(
                  child: Text(
                    'No transactions match your filters',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = filteredExpenses[index];
                    return _buildExpenseCard(expense, index);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildExpenseCard(Expense expense, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                    _getPaymentIcon(index),
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

  String _getPaymentIcon(int index) {
    final icons = [
      'assets/gpay.png',
      'assets/phonepe.png',
      'assets/paytm.png',
    ];
    return icons[index % icons.length];
  }
}

class Expense {
  final String name;
  final IconData icon;
  final int amountValue;
  final Color color;
  final String paymentMethod;
  
  Expense(this.name, this.icon, this.amountValue, this.color, this.paymentMethod);
  
  String get amount => amountValue.toString();
}
