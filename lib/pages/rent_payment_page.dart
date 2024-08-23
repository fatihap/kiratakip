import 'package:flutter/material.dart';
import 'package:kiratakip/auth/widgets/sign_in_form.dart';

import '../classes/rent_payment_class.dart';
import '../classes/tenant_class.dart';

class RentPaymentPage extends StatefulWidget {
  final Tenant tenant;

  const RentPaymentPage({super.key, required this.tenant});

  @override
  _RentPaymentPageState createState() => _RentPaymentPageState();
}

class _RentPaymentPageState extends State<RentPaymentPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.tenant.name} - Kira Ödemeleri',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          backgroundColor: Colors.teal,
          elevation: 4,
          actions: [
            IconButton(
              onPressed: () => () {},
              //_navigateToTenantInfo(context),
              icon: const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
            ),
          ],
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SignInForm(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void handlePaymentChange(RentPayment payment) {
    setState(() {
      final updatedPayment = payment.copyWith(
        isPaid: !payment.isPaid,
        paymentDate: payment.isPaid ? null : DateTime.now(),
      );
    });
  }
}
