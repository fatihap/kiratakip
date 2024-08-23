import 'package:flutter/material.dart';

class TenantDetailHeader extends StatelessWidget {
  final String tenantName;
  final List payments;
  final Function(int) onPaymentTap;

  const TenantDetailHeader({
    required this.tenantName,
    required this.payments,
    required this.onPaymentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$tenantName Kira Ödemeleri:',
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Toplam Ödeme: ${payments.length} Ay',
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
