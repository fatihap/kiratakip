import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../classes/constants.dart';

class EditTenantPage extends StatefulWidget {
  final String token;
  final int tenantId;
  final Map<String, dynamic>? tenantDetails;

  const EditTenantPage({
    super.key,
    required this.token,
    required this.tenantId,
    this.tenantDetails,
  });

  @override
  _EditTenantPageState createState() => _EditTenantPageState();
}

class _EditTenantPageState extends State<EditTenantPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _contractDurationController;
  late TextEditingController _rentAmountController;
  late TextEditingController _descriptionController;
  late DateTime _startDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tenantDetails?['tenant_name']);
    _surnameController = TextEditingController(text: widget.tenantDetails?['tenant_surname']);
    _phoneController = TextEditingController(text: widget.tenantDetails?['phone']);
    _addressController = TextEditingController(text: widget.tenantDetails?['address']);
    _contractDurationController = TextEditingController(text: widget.tenantDetails?['contract_duration'].toString());
    _rentAmountController = TextEditingController(text: widget.tenantDetails?['rent_amount'].toString());
    _descriptionController = TextEditingController(text: widget.tenantDetails?['description']);
    _startDate = DateTime.parse(widget.tenantDetails?['start_date'] ?? DateTime.now().toString());
  }

  Future<void> _updateTenant() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final response = await http.put(
      Uri.parse('${Constants.apiUrl}/tenant/${widget.tenantId}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "name": _nameController.text,
        "surname": _surnameController.text,
        "phone": _phoneController.text,
        "address": _addressController.text,
        "contract_duration": int.parse(_contractDurationController.text),
        "rent_amount": int.parse(_rentAmountController.text),
        "start_date": DateFormat('yyyy-MM-dd').format(_startDate),
        "description": _descriptionController.text,
        "type": widget.tenantDetails?['type'],  // Kiracı tipi değişmeden aynı kalıyor
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kiracı başarıyla güncellendi')),
      );
      Navigator.of(context).pop(true); // Düzenleme sonrası geri dönüş
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Güncellenemedi: ${response.reasonPhrase}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiracı Düzenle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Adı'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Adı girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _surnameController,
                  decoration: const InputDecoration(labelText: 'Soyadı'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Soyadı girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Telefon'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Telefon girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Adres'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _contractDurationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Sözleşme Süresi (ay)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Sözleşme süresi girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _rentAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Kira Miktarı (TL)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kira miktarını girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Açıklama'),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: Text('Sözleşme Başlangıç Tarihi: ${DateFormat('yyyy-MM-dd').format(_startDate)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _startDate) {
                        setState(() {
                          _startDate = picked;
                        });
                      }
                    },
                  ),
                ),
              
                ElevatedButton(
                  onPressed: _updateTenant,
                  child: const Text('Kaydet'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
