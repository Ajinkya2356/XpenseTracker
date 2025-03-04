import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserSettings extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  String _currencyCode = 'INR';
  String _currencySymbol = '₹';
  String? _defaultUpiApp;
  bool _isLoading = true;

  String get currencyCode => _currencyCode;
  String get currencySymbol => _currencySymbol;
  String? get defaultUpiApp => _defaultUpiApp;
  bool get isLoading => _isLoading;

  Future<void> loadUserSettings() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      final response = await _supabase
          .from('user_settings')
          .select()
          .eq('user_id', user.id)
          .single();

      _currencyCode = response['currency_code'] ?? 'INR';
      _currencySymbol = response['currency_symbol'] ?? '₹';
      _defaultUpiApp = response['default_upi_app'];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // If no settings exist, create default settings
      await _createDefaultSettings();
    }
  }

  Future<void> _createDefaultSettings() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      await _supabase.from('user_settings').upsert({
        'user_id': user.id,
        'currency_code': 'INR',
        'currency_symbol': '₹',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      _currencyCode = 'INR';
      _currencySymbol = '₹';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error creating default settings: $e');
    }
  }

  Future<void> updateCurrency(String code, String symbol) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      await _supabase.from('user_settings').upsert({
        'user_id': user.id,
        'currency_code': code,
        'currency_symbol': symbol,
        'updated_at': DateTime.now().toIso8601String(),
      });

      _currencyCode = code;
      _currencySymbol = symbol;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating currency: $e');
      rethrow;
    }
  }

  Future<void> updateDefaultUpiApp(String appName) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      await _supabase.from('user_settings').upsert({
        'user_id': user.id,
        'default_upi_app': appName,
        'updated_at': DateTime.now().toIso8601String(),
      });

      _defaultUpiApp = appName;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating default UPI app: $e');
      rethrow;
    }
  }
}
