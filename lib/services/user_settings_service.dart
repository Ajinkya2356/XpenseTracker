import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'local_storage_service.dart';

class UserSettings with ChangeNotifier {
  final SupabaseClient _supabase;
  final LocalStorageService _localStorage;
  
  String _currencyCode = 'INR';
  String _currencySymbol = '₹';
  String? _defaultUpiApp;
  bool _isDirty = false;

  UserSettings(this._supabase, this._localStorage) {
    _loadFromLocal();
  }

  // Getters
  String get currencyCode => _currencyCode;
  String get currencySymbol => _currencySymbol;
  String? get defaultUpiApp => _defaultUpiApp;

  Future<void> _loadFromLocal() async {
    final settings = _localStorage.getUserSettings();
    if (settings != null) {
      _currencyCode = settings['currency_code'] ?? 'INR';
      _currencySymbol = settings['currency_symbol'] ?? '₹';
      _defaultUpiApp = settings['default_upi_app'];
      notifyListeners();
    } else {
      await _loadFromDatabase();
    }
  }

  Future<void> _loadFromDatabase() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await _supabase
          .from('user_settings')
          .select()
          .eq('user_id', userId)
          .single();

      if (response != null) {
        _currencyCode = response['currency_code'] ?? 'INR';
        _currencySymbol = response['currency_symbol'] ?? '₹';
        _defaultUpiApp = response['default_upi_app'];
        
        // Save to local storage
        await _saveToLocal();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading settings from DB: $e');
    }
  }

  Future<void> _saveToLocal() async {
    await _localStorage.saveUserSettings({
      'currency_code': _currencyCode,
      'currency_symbol': _currencySymbol,
      'default_upi_app': _defaultUpiApp,
    });
  }

  Future<void> syncToDatabase() async {
    if (!_isDirty) return;

    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      await _supabase.from('user_settings').upsert({
        'user_id': userId,
        'currency_code': _currencyCode,
        'currency_symbol': _currencySymbol,
        'default_upi_app': _defaultUpiApp,
      });

      _isDirty = false;
    } catch (e) {
      debugPrint('Error syncing settings to DB: $e');
    }
  }

  Future<void> updateCurrency(String code, String symbol) async {
    _currencyCode = code;
    _currencySymbol = symbol;
    _isDirty = true;
    await _saveToLocal();
    notifyListeners();
    await syncToDatabase();
  }

  Future<void> updateDefaultUpiApp(String packageName) async {
    _defaultUpiApp = packageName;
    _isDirty = true;
    await _saveToLocal();
    notifyListeners();
    await syncToDatabase();
  }
}
