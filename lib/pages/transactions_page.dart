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
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Category',
                border: OutlineInputBorder(),
              ),
              value: selectedCategories.isEmpty ? null : selectedCategories.first,
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category['name'] as String,
                  child: Text(category['name'] as String),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    selectedCategories = [value];
                    _isFilterChanged = true;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            // Payment Method Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Payment Method',
                border: OutlineInputBorder(),
              ),
              value: selectedPaymentMethods.isEmpty ? null : selectedPaymentMethods.first,
              items: paymentMethods.map((method) {
                return DropdownMenuItem(
                  value: method['name'] as String,
                  child: Text(method['name'] as String),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    selectedPaymentMethods = [value];
                    _isFilterChanged = true;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    _resetFilters();
                    Navigator.pop(context);
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _applyFilters();
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
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