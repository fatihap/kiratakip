import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../classes/constants.dart';
import '../../../classes/tenant_class.dart';

class AddTenantForm extends StatefulWidget {
  final String token;
  final Function(Tenant) onTenantAdded;

  const AddTenantForm({
    required this.token,
    required this.onTenantAdded,
  });

  @override
  _AddTenantFormState createState() => _AddTenantFormState();
}

class _AddTenantFormState extends State<AddTenantForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _contractDurationController;
  late final TextEditingController _rentAmountController;
  late final TextEditingController _startDateController;
  late final TextEditingController _descriptionController;
  int _selectedType = 1;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty text
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _contractDurationController = TextEditingController();
    _rentAmountController = TextEditingController();
    _startDateController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _contractDurationController.dispose();
    _rentAmountController.dispose();
    _startDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final tenant = Tenant(
      id: 0,
      name: _nameController.text,
      surname: _surnameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      contract_duration: int.tryParse(_contractDurationController.text) ?? 0,
      rent_amount: int.tryParse(_rentAmountController.text) ?? 0,
      start_date: _startDateController.text,
      description: _descriptionController.text,
      type: 1,
    );

    final url = '${Constants.apiUrl}/tenant';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(tenant.toJson()),
    );

    if (response.statusCode == 200) {
      widget.onTenantAdded(tenant);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Kiracı kaydedilemedi: ${response.reasonPhrase}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            TenantTypeSelector(
              selectedType: _selectedType,
              onChanged: (int? value) {
                setState(() {
                  _selectedType = value ?? 1;
                });
              },
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Ad'),
            ),
            TextFormField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: 'Soyad'),
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Telefon'),
            ),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Adres'),
            ),
            TextFormField(
              controller: _contractDurationController,
              decoration:
                  const InputDecoration(labelText: 'Sözleşme Süresi (Ay)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _rentAmountController,
              decoration: const InputDecoration(labelText: 'Kira Miktarı'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _startDateController,
              decoration: const InputDecoration(
                  labelText: 'Başlangıç Tarihi (YYYY-MM-DD)'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Açıklama'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}

class TenantTypeSelector extends StatelessWidget {
  final int selectedType;
  final ValueChanged<int?> onChanged; 

  const TenantTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      const Text(
          'Kiracı Türü Seçin',
          style: TextStyle(fontSize: 18),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<int>(
                title: const Text('Daire'),
                value: 1,
                groupValue: selectedType,
                onChanged: onChanged,
              ),
            ),
            Expanded(
              child: RadioListTile<int>(
                title:const  Text('Dükkan'),
                value: 2,
                groupValue: selectedType,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
