import 'package:flutter/material.dart';

class PaymentCard extends StatelessWidget {
  final String paymentMonth;
  final dynamic amount;
  final bool isPaid;
  final VoidCallback onTap;

  const PaymentCard({
    super.key,
    required this.paymentMonth,
    required this.amount,
    required this.isPaid,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5,
      child: ListTile(
        title: Text(paymentMonth,
            style:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        subtitle: Text('Kira Miktarı: $amount TL'),
        trailing: isPaid
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.cancel, color: Colors.red),
        onTap: onTap,
      ),
    );
  }
}
