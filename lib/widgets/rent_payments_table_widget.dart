import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/rent_payment_class.dart';
import '../classes/tenant_class.dart';

class RentPaymentsTable extends StatelessWidget {
  final Tenant tenant;
  final List<RentPayment> payments;
  final Function(RentPayment) onPaymentChanged;
  final Function(BuildContext, RentPayment) onPaymentEdit;

  const RentPaymentsTable({
    super.key,
    required this.tenant,
    required this.payments,
    required this.onPaymentChanged,
    required this.onPaymentEdit,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Ay')),
        DataColumn(label: Text('Kira Miktarı')),
        DataColumn(label: Text('Ödenen Miktar')),
        DataColumn(label: Text('Durum')),
        DataColumn(label: Text('Düzenle')),
      ],
      rows: payments.map((payment) {
        return DataRow(
          cells: [
            DataCell(Text(_getMonthWithYear(payment.month))),
            DataCell(Text(tenant.rentAmount.toString())),  
            DataCell(Text(payment.isPaid ? payment.amount.toString() : '0')),
            DataCell(
              Row(
                children: [
                  Checkbox(
                    value: payment.isPaid,
                    onChanged: (bool? value) {
                      if (value != null) {
                        onPaymentChanged(payment);
                      }
                    },
                  ),
                  Text(payment.isPaid ? 'Ödendi' : 'Ödenmedi'),
                ],
              ),
            ),
            DataCell(
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  onPaymentEdit(context, payment);
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _getMonthWithYear(String monthYear) {
    return DateFormat('MMMM yyyy', 'tr_TR').format(DateFormat('MMMM yyyy').parse(monthYear));
  }
}
