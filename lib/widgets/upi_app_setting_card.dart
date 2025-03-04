import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_settings_service.dart';
import '../services/upi_service.dart';
import '../config/theme_config.dart';

class UpiAppSettingCard extends StatelessWidget {
  final VoidCallback onTap;

  const UpiAppSettingCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.mobile_friendly, color: Colors.purple),
        ),
        title: const Text('Default UPI App'),
        subtitle: Builder(
          builder: (context) {
            final defaultApp = context.select((UserSettings s) => s.defaultUpiApp);
            return Text(UpiService.getAppDisplayName(defaultApp ?? 'None'));
          },
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
