import 'package:flutter/material.dart';

import '../classes/rent_payment_class.dart';

class AddPaymentDialog extends StatefulWidget {
  final Function(RentPayment) onPaymentAdded;
  final RentPayment payment;

  const AddPaymentDialog(
      {super.key, required this.onPaymentAdded, required this.payment});

  @override
  _AddPaymentDialogState createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends State<AddPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  late double _amount;

  @override
  void initState() {
    super.initState();
    _amount = widget.payment.amount;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ödeme Ekle'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: widget.payment.amount.toString(),
              decoration: const InputDecoration(labelText: 'Kira Miktarı'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen kira miktarını girin';
                }
                return null;
              },
              onSaved: (value) {
                _amount = double.parse(value!);
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('İptal'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Ekle'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final newPayment = widget.payment.copyWith(
                amount: _amount,
                isPaid: true,
                paymentDate: DateTime.now(),
              );
              widget.onPaymentAdded(newPayment);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
