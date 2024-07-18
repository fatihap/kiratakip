import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/rent_payment_class.dart';
import '../classes/tenant_class.dart';
import '../helpers/dbhelper.dart';
import '../widgets/edit_payment_dialog.dart';
import '../widgets/rent_payments_table_widget.dart';
import '../widgets/reusable_button_row_widget.dart';
import '../widgets/showTenantInfo_widget.dart';
import 'add_payment_dialog_widget.dart';

class RentPaymentPage extends StatefulWidget {
  final Tenant tenant;

  const RentPaymentPage({super.key, required this.tenant});

  @override
  _RentPaymentPageState createState() => _RentPaymentPageState();
}

class _RentPaymentPageState extends State<RentPaymentPage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    updatePaymentList();
  }

  void updatePaymentList() async {
    widget.tenant.rentPayments = await dbHelper.getPaymentList(widget.tenant.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.tenant.name} - Kira Ödemeleri'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RentPaymentsTable(
                  tenant: widget.tenant,
                  payments: _generateRentPayments(),
                  onPaymentChanged: _handlePaymentChange,
                  onPaymentEdit: _showEditPaymentDialog,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ReusableButtonRow(
              showTenantInfo: () => _navigateToTenantInfo(context),
            ),
          ),
        ],
      ),
    );
  }

  List<RentPayment> _generateRentPayments() {
    List<RentPayment> payments = [];
    DateTime currentDate = widget.tenant.startDate;

    // Set the locale to Turkish
    Intl.defaultLocale = 'tr_TR';

    payments.addAll(widget.tenant.rentPayments);

    for (int i = 0; i < widget.tenant.contractDuration * 12; i++) {
      final monthYear = DateFormat('MMMM yyyy', 'tr_TR').format(currentDate);

      if (!payments.any((p) => p.month == monthYear)) {
        payments.add(RentPayment(
          tenantId: widget.tenant.id!,
          month: monthYear,
          amount: widget.tenant.rentAmount,
          isPaid: false,
        ));
      }

      currentDate = DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
    }

    payments.sort((a, b) => DateFormat('MMMM yyyy', 'tr_TR').parse(a.month).compareTo(DateFormat('MMMM yyyy', 'tr_TR').parse(b.month)));

    return payments;
  }

  void _handlePaymentChange(RentPayment payment) {
    setState(() {
      final updatedPayment = payment.copyWith(
        isPaid: !payment.isPaid,
        paymentDate: payment.isPaid ? null : DateTime.now(),
      );

      if (updatedPayment.isPaid) {
        _showAddPaymentDialog(context, updatedPayment);
      } else {
        dbHelper.updatePayment(updatedPayment);
        updatePaymentList();
      }
    });
  }

  void _navigateToTenantInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TenantInfoPage(tenant: widget.tenant),
      ),
    );
  }

  void _showAddPaymentDialog(BuildContext context, RentPayment? payment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPaymentDialog(
          onPaymentAdded: (newPayment) {
            newPayment = newPayment.copyWith(tenantId: widget.tenant.id);
            dbHelper.insertPayment(newPayment).then((value) {
              updatePaymentList();
            });
          },
          payment: payment ?? RentPayment(
            tenantId: widget.tenant.id!,
            month: '',
            amount: widget.tenant.rentAmount,
            isPaid: false,
          ),
        );
      },
    );
  }

  void _showEditPaymentDialog(BuildContext context, RentPayment payment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditPaymentDialog(
          onPaymentUpdated: (updatedPayment) {
            dbHelper.updatePayment(updatedPayment).then((value) {
              updatePaymentList();
            });
          },
          payment: payment,
        );
      },
    );
  }
}
