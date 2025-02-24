import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Add this for RangeValues

class ExpenseFilters extends ChangeNotifier {
  String searchQuery = '';
  Set<String> selectedCategories = {};
  Set<String> selectedPaymentMethods = {};
  RangeValues amountRange = const RangeValues(0, 10000);
  DateTime? startDate;
  DateTime? endDate;

  void updateSearch(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    notifyListeners();
  }

  void togglePaymentMethod(String method) {
    if (selectedPaymentMethods.contains(method)) {
      selectedPaymentMethods.remove(method);
    } else {
      selectedPaymentMethods.add(method);
    }
    notifyListeners();
  }

  void updateAmountRange(RangeValues range) {
    amountRange = range;
    notifyListeners();
  }

  void updateDateRange(DateTime? start, DateTime? end) {
    startDate = start;
    endDate = end;
    notifyListeners();
  }

  void reset() {
    searchQuery = '';
    selectedCategories.clear();
    selectedPaymentMethods.clear();
    amountRange = const RangeValues(0, 10000);
    startDate = null;
    endDate = null;
    notifyListeners();
  }

  bool get hasActiveFilters => 
    searchQuery.isNotEmpty ||
    selectedCategories.isNotEmpty ||
    selectedPaymentMethods.isNotEmpty ||
    startDate != null ||
    amountRange != const RangeValues(0, 10000);

  List<Map<String, dynamic>> filterExpenses(List<dynamic> expenses) {
    return expenses.map((expense) {
      if (expense is Map<String, dynamic>) {
        return expense;
      } else {
        // Convert Expense object to Map
        return {
          'name': expense.name,
          'amount': expense.amountValue.toString(),
          'category': expense.name,
          'paymentMethod': expense.paymentMethod,
          'dateTime': DateTime.now().toString(), // Add proper date handling
        };
      }
    }).where((expense) {
      // Search query filter
      if (searchQuery.isNotEmpty && 
          !expense['name'].toString().toLowerCase().contains(searchQuery.toLowerCase())) {
        return false;
      }

      // Category filter
      if (selectedCategories.isNotEmpty && 
          !selectedCategories.contains(expense['category'])) {
        return false;
      }

      // Payment method filter
      if (selectedPaymentMethods.isNotEmpty && 
          !selectedPaymentMethods.contains(expense['paymentMethod'])) {
        return false;
      }

      // Amount range filter
      final amount = double.parse(expense['amount'].toString().replaceAll(',', ''));
      if (amount < amountRange.start || amount > amountRange.end) {
        return false;
      }

      // Date range filter
      if (startDate != null && endDate != null) {
        final expenseDate = DateTime.parse(expense['dateTime']);
        if (expenseDate.isBefore(startDate!) || expenseDate.isAfter(endDate!)) {
          return false;
        }
      }

      return true;
    }).toList();
  }
}
