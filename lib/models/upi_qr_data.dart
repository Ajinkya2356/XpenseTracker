class UpiQrData {
  final String? payeeName;
  final String? payeeVpa;
  final double? amount;
  final String? transactionNote;
  final String? merchantCode;
  final String? merchantName;
  final String rawQrData;

  UpiQrData({
    this.payeeName,
    this.payeeVpa,
    this.amount,
    this.transactionNote,
    this.merchantCode,
    this.merchantName,
    required this.rawQrData,
  });

  factory UpiQrData.fromQrString(String qrString) {
    final Map<String, String> params = {};
    
    // Parse URL-style parameters
    if (qrString.contains('?')) {
      final queryParams = qrString.split('?')[1].split('&');
      for (var param in queryParams) {
        final parts = param.split('=');
        if (parts.length == 2) {
          params[parts[0]] = Uri.decodeComponent(parts[1]);
        }
      }
    }

    return UpiQrData(
      payeeName: params['pn'],
      payeeVpa: params['pa'],
      amount: params['am'] != null ? double.tryParse(params['am']!) : null,
      transactionNote: params['tn'],
      merchantCode: params['mc'],
      merchantName: params['mn'],
      rawQrData: qrString,
    );
  }

  Map<String, dynamic> toExpenseData(String userId) {
    return {
      'user_id': userId,
      'category_id': 'ecfd388f-6cda-40f3-a1d0-66df131d113a', // Default category
      'amount': amount,
      'description': transactionNote,
      'merchant_name': merchantName ?? payeeName,
      'expense_date': DateTime.now().toIso8601String(),
      'payment_method': 'UPI',
      'qr_data': rawQrData,
    };
  }
}
