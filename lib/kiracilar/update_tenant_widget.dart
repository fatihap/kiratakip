// ignore: file_names
import 'package:flutter/material.dart';

import '../classes/tenant_class.dart';
import '../helpers/dbhelper.dart';

class EditTenantPage extends StatefulWidget {
  final Tenant tenant;

  const EditTenantPage({super.key, required this.tenant});

  @override
  _EditTenantPageState createState() => _EditTenantPageState();
}

class _EditTenantPageState extends State<EditTenantPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _contractDurationController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _rentAmountController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tenant.name);
    _addressController = TextEditingController(text: widget.tenant.address);
    _contractDurationController = TextEditingController(text: widget.tenant.contractDuration.toString());
    _phoneNumberController = TextEditingController(text: widget.tenant.phoneNumber);
    _rentAmountController = TextEditingController(text: widget.tenant.rentAmount.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contractDurationController.dispose();
    _phoneNumberController.dispose();
    _rentAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiracı Bilgilerini Düzenle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Adı Soyadı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen adı soyadı giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Adres'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen adresi giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contractDurationController,
                decoration: const InputDecoration(labelText: 'Kontrat Süresi (Ay)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen kontrat süresini giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Telefon Numarası'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen telefon numarasını giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _rentAmountController,
                decoration: const InputDecoration(labelText: 'Kira Miktarı (TL)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen kira miktarını giriniz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedTenant = Tenant(
                      id: widget.tenant.id,
                      name: _nameController.text,
                      address: _addressController.text,
                      contractDuration: int.parse(_contractDurationController.text),
                      phoneNumber: _phoneNumberController.text,
                      rentAmount: double.parse(_rentAmountController.text),
                      startDate: widget.tenant.startDate, // Keep the existing start date
                    );
                    DatabaseHelper.instance.updateTenant(updatedTenant).then((value) {
                      Navigator.pop(context, true);
                    });
                  }
                },
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
