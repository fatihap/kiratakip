import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'payment_card.dart';

class PaymentList extends StatelessWidget {
  final List payments;
  final String startDate;
  final Function(int) onPaymentTap;

  const PaymentList({
    super.key,
    required this.payments,
    required this.startDate,
    required this.onPaymentTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        final DateTime startDateTime = DateTime.parse(startDate);
        final DateTime paymentDate =
            DateTime(startDateTime.year, startDateTime.month + index);
        final paymentMonth =
            DateFormat('MMMM yyyy', 'tr_TR').format(paymentDate);

        return PaymentCard(
          paymentMonth: paymentMonth,
          amount: payment['amount'],
          isPaid: payment['is_paid'] == '1',
          onTap: () => onPaymentTap(index),
        );
      },
    );
  }
}
