import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final TextEditingController _searchController = TextEditingController();
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
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: ThemeConfig.surfaceColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ThemeConfig.primaryColor, ThemeConfig.darkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Text(
                    'Filter Expenses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Filter Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories Section
                  Row(
                    children: [
                      const Icon(Icons.category, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      if (selectedCategories.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedCategories.clear();
                              _applyFilters();
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Clear'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((category) {
                      final isSelected = selectedCategories.contains(category['name']);
                      return FilterChip(
                        selected: isSelected,
                        showCheckmark: true,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              category['icon'] as IconData,
                              size: 16,
                              color: isSelected ? Colors.white : category['color'] as Color,
                            ),
                            const SizedBox(width: 4),
                            Text(category['name'] as String),
                          ],
                        ),
                        backgroundColor: (category['color'] as Color).withOpacity(0.1),
                        selectedColor: category['color'] as Color,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : category['color'] as Color,
                          fontWeight: FontWeight.w500,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : (category['color'] as Color).withOpacity(0.5),
                          ),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedCategories.add(category['name'] as String);
                            } else {
                              selectedCategories.remove(category['name']);
                            }
                            _applyFilters();
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Payment Methods Section
                  Row(
                    children: [
                      const Icon(Icons.payment, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Payment Methods',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      if (selectedPaymentMethods.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedPaymentMethods.clear();
                              _applyFilters();
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Clear'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: paymentMethods.map((method) {
                      final isSelected = selectedPaymentMethods.contains(method['name']);
                      return FilterChip(
                        selected: isSelected,
                        showCheckmark: true,
                        label: Text(method['name'] as String),
                        backgroundColor: Colors.grey.withOpacity(0.1),
                        selectedColor: ThemeConfig.primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedPaymentMethods.add(method['name'] as String);
                            } else {
                              selectedPaymentMethods.remove(method['name']);
                            }
                            _applyFilters();
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
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

  void _onSearchChanged() {
    final searchQuery = _searchController.text.toLowerCase();
    setState(() {
      filteredExpenses = allExpenses.where((expense) {
        final matchesSearch = expense.name.toLowerCase().contains(searchQuery) ||
            expense.paymentMethod.toLowerCase().contains(searchQuery);
        final matchesCategory = selectedCategories.isEmpty ||
            selectedCategories.contains(expense.name);
        final matchesPayment = selectedPaymentMethods.isEmpty ||
            selectedPaymentMethods.contains(expense.paymentMethod);
        return matchesSearch && matchesCategory && matchesPayment;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar with filters
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: ThemeConfig.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search expenses',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),

              // Active Filters
              if (selectedCategories.isNotEmpty || selectedPaymentMethods.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list, size: 16),
                      const SizedBox(width: 8),
                      const Text('Active Filters:'),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            selectedCategories.clear();
                            selectedPaymentMethods.clear();
                            _onSearchChanged();
                          });
                        },
                        icon: const Icon(Icons.clear_all, size: 16),
                        label: const Text('Clear All'),
                      ),
                    ],
                  ),
                ),

              // Filter Options
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Categories Filter
                    PopupMenuButton<String>(
                      child: Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.category, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              selectedCategories.isEmpty
                                  ? 'Categories'
                                  : '${selectedCategories.length} Selected',
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (context) => categories.map((category) {
                        return CheckedPopupMenuItem<String>(
                          value: category['name'] as String,
                          checked: selectedCategories.contains(category['name']),
                          child: Row(
                            children: [
                              Icon(
                                category['icon'] as IconData,
                                color: category['color'] as Color,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(category['name'] as String),
                            ],
                          ),
                        );
                      }).toList(),
                      onSelected: (value) {
                        setState(() {
                          if (selectedCategories.contains(value)) {
                            selectedCategories.remove(value);
                          } else {
                            selectedCategories.add(value);
                          }
                          _onSearchChanged();
                        });
                      },
                    ),
                    const SizedBox(width: 8),

                    // Payment Methods Filter
                    PopupMenuButton<String>(
                      child: Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.payment, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              selectedPaymentMethods.isEmpty
                                  ? 'Payment Methods'
                                  : '${selectedPaymentMethods.length} Selected',
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (context) => paymentMethods.map((method) {
                        final name = method['name'] as String;
                        return CheckedPopupMenuItem<String>(
                          value: name,
                          checked: selectedPaymentMethods.contains(name),
                          child: Text(name),
                        );
                      }).toList(),
                      onSelected: (value) {
                        setState(() {
                          if (selectedPaymentMethods.contains(value)) {
                            selectedPaymentMethods.remove(value);
                          } else {
                            selectedPaymentMethods.add(value);
                          }
                          _onSearchChanged();
                        });
                      },
                    ),
                  ],
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
                Text(
                  expense.paymentMethod,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
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