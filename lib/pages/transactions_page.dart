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
      backgroundColor: ThemeConfig.darkColor,
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
                      color: Color.fromARGB(255, 12, 12, 12),
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
        // Search and Filter Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ThemeConfig.darkColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: ThemeConfig.surfaceColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[800]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[400]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search expenses',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[400]),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged();
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Filter Options Row
              Row(
                children: [
                  // Categories Dropdown
                  Expanded(
                    child: IntrinsicWidth( // Added IntrinsicWidth
                      child: PopupMenuButton<String>(
                        constraints: const BoxConstraints(
                          minWidth: 180,
                          maxWidth: 220,
                        ),
                        position: PopupMenuPosition.under,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: selectedCategories.isEmpty 
                                ? ThemeConfig.surfaceColor.withOpacity(0.1)
                                : ThemeConfig.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectedCategories.isEmpty
                                  ? Colors.grey[800]!
                                  : ThemeConfig.primaryColor.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Added this
                            children: [
                              Icon(
                                Icons.category_outlined,
                                size: 18,
                                color: selectedCategories.isEmpty 
                                    ? Colors.grey[400]
                                    : ThemeConfig.primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                selectedCategories.isEmpty
                                    ? 'Categories'
                                    : '${selectedCategories.length} Selected',
                                style: TextStyle(
                                  color: selectedCategories.isEmpty 
                                      ? Colors.grey[400]
                                      : ThemeConfig.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 8), // Changed from Spacer
                              Icon(
                                Icons.arrow_drop_down,
                                color: selectedCategories.isEmpty 
                                    ? Colors.grey[400]
                                    : ThemeConfig.primaryColor,
                              ),
                            ],
                          ),
                        ),
                        itemBuilder: (context) => [
                          ...categories.map((category) {
                            return CheckedPopupMenuItem<String>(
                              value: category['name'] as String,
                              checked: selectedCategories.contains(category['name']),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Icon(
                                    category['icon'] as IconData,
                                    color: category['color'] as Color,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    category['name'] as String,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
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
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Payment Methods Dropdown
                  Expanded(
                    child: IntrinsicWidth( // Added IntrinsicWidth
                      child: PopupMenuButton<String>(
                        constraints: const BoxConstraints(
                          minWidth: 180,
                          maxWidth: 220,
                        ),
                        position: PopupMenuPosition.under,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: selectedPaymentMethods.isEmpty 
                                ? ThemeConfig.surfaceColor.withOpacity(0.1)
                                : ThemeConfig.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectedPaymentMethods.isEmpty
                                  ? Colors.grey[800]!
                                  : ThemeConfig.primaryColor.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Added this
                            children: [
                              Icon(
                                Icons.payment_outlined,
                                size: 18,
                                color: selectedPaymentMethods.isEmpty 
                                    ? Colors.grey[400]
                                    : ThemeConfig.primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                selectedPaymentMethods.isEmpty
                                    ? 'Payment'
                                    : '${selectedPaymentMethods.length} Selected',
                                style: TextStyle(
                                  color: selectedPaymentMethods.isEmpty 
                                      ? Colors.grey[400]
                                      : ThemeConfig.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 8), // Changed from Spacer
                              Icon(
                                Icons.arrow_drop_down,
                                color: selectedPaymentMethods.isEmpty 
                                    ? Colors.grey[400]
                                    : ThemeConfig.primaryColor,
                              ),
                            ],
                          ),
                        ),
                        itemBuilder: (context) => paymentMethods.map((method) {
                          return CheckedPopupMenuItem<String>(
                            value: method['name'] as String,
                            checked: selectedPaymentMethods.contains(method['name']),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Text(
                              method['name'] as String,
                              style: const TextStyle(fontSize: 15),
                            ),
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
                    ),
                  ),
                ],
              ),

              // Active Filters
              if (selectedCategories.isNotEmpty || selectedPaymentMethods.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            selectedCategories.clear();
                            selectedPaymentMethods.clear();
                            _onSearchChanged();
                          });
                        },
                        icon: Icon(Icons.clear_all, size: 16, color: Colors.grey[400]),
                        label: Text(
                          'Clear Filters',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
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