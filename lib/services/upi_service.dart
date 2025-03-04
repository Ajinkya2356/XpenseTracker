import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:url_launcher/url_launcher.dart';

class UpiService {
  static final Map<String, String> upiApps = {
    'com.google.android.apps.nbu.paisa.user': 'Google Pay',
    'com.phonepe.app': 'PhonePe',
    'net.one97.paytm': 'Paytm',
    'in.amazonpay': 'Amazon Pay',
    'com.whatsapp': 'WhatsApp Pay',
    'com.csam.icici.bank.imobile': 'iMobile Pay',
  };

  static Future<List<AppInfo>> getInstalledUpiApps() async {
    try {
      debugPrint('Fetching installed apps...');
      List<AppInfo> allApps = await InstalledApps.getInstalledApps(true, true);
      debugPrint('Found ${allApps.length} installed apps');
      
      // Filter UPI apps and log for debugging
      List<AppInfo> upiApps = allApps.where((app) {
        bool isUpiApp = UpiService.upiApps.containsKey(app.packageName);
        if (isUpiApp) {
          debugPrint('Found UPI app: ${app.packageName}');
        }
        return isUpiApp;
      }).toList();
      
      debugPrint('Found ${upiApps.length} UPI apps');
      return upiApps;
    } catch (e) {
      debugPrint('Error getting installed apps: $e');
      return [];
    }
  }

  static String getAppDisplayName(String packageName) {
    return upiApps[packageName] ?? packageName;
  }

  static Future<bool> launchUpiUrl(String upiUrl) async {
    try {
      final uri = Uri.parse(upiUrl);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
