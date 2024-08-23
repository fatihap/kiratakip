import 'package:flutter/material.dart';

import '../../classes/tenant_class.dart';
import 'Widgets/add_tenant_form_widget.dart';

class AddTenantPage extends StatefulWidget {
  final Function(Tenant) onTenantAdded;
  final String token;
  final Tenant? tenant;

  const AddTenantPage(
      {super.key,
      required this.onTenantAdded,
      this.tenant,
      required this.token});

  @override
  _AddTenantPageState createState() => _AddTenantPageState();
}

class _AddTenantPageState extends State<AddTenantPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Kiracı Ekle',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.teal,
          elevation: 4,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AddTenantForm(
                  token: widget.token,
                  onTenantAdded: widget.onTenantAdded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
