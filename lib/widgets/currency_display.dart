import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_settings_service.dart';

class CurrencyDisplay extends StatelessWidget {
  final num amount;
  final TextStyle? style;
  final bool compact;

  const CurrencyDisplay({
    super.key,
    required this.amount,
    this.style,
    this.compact = false,
  });

  String _formatAmount() {
    if (compact && amount >= 1000) {
      if (amount >= 100000) {
        return '${(amount / 100000).toStringAsFixed(1)}L';
      }
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSettings>(
      builder: (context, settings, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              settings.currencySymbol,
              style: style,
            ),
            const SizedBox(width: 2),
            Text(_formatAmount(), style: style),
          ],
        );
      },
    );
  }
}
