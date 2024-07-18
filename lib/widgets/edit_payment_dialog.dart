import 'package:flutter/material.dart';

import '../classes/rent_payment_class.dart';

class EditPaymentDialog extends StatefulWidget {
  final RentPayment payment;
  final Function(RentPayment) onPaymentUpdated;

  const EditPaymentDialog({
    super.key,
    required this.payment,
    required this.onPaymentUpdated,
  });

  @override
  _EditPaymentDialogState createState() => _EditPaymentDialogState();
}

class _EditPaymentDialogState extends State<EditPaymentDialog> {
  final TextEditingController _amountPaidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountPaidController.text = widget.payment.isPaid ? widget.payment.amount.toString() : '0';
  }

  @override
  void dispose() {
    _amountPaidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ödenen Miktarı Düzenle'),
      content: TextField(
        controller: _amountPaidController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Ödenen Miktar'),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('İptal'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Kaydet'),
          onPressed: () {
            final updatedPayment = widget.payment.copyWith(
              amount: double.tryParse(_amountPaidController.text) ?? widget.payment.amount,
              isPaid: true,
              paymentDate: DateTime.now(),
            );
            widget.onPaymentUpdated(updatedPayment);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
