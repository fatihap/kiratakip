import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/tenant_class.dart';
import '../helpers/dbhelper.dart';

class AddTenantPage extends StatefulWidget {
  const AddTenantPage({super.key});

  @override
  _AddTenantPageState createState() => _AddTenantPageState();
}

class _AddTenantPageState extends State<AddTenantPage> {
  late String name;
  late String address;
  late int contractDuration;
  late String phoneNumber;
  late double rentAmount;
  late DateTime startDate;
  String startDateText = "Kira Başlangıç Tarihini Seç";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnackBar(String message, [bool isError = false]) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _insertTenant() async {
    try {
      Tenant newTenant = Tenant(
        name: name,
        address: address,
        contractDuration: contractDuration,
        phoneNumber: phoneNumber,
        rentAmount: rentAmount,
        startDate: startDate,
        rentPayments: [],
      );

      int result = await DatabaseHelper.instance.insertTenant(newTenant);
      if (result != 0) {
        _showSnackBar('Kiracı başarıyla eklendi!');
        Navigator.pop(context, newTenant);
      } else {
        _showSnackBar('Kiracı eklenirken bir hata oluştu!', true);
      }
    } catch (e) {
      _showSnackBar('Bir hata meydana geldi: ${e.toString()}', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Yeni Kiracı Ekle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Adı Soyadı'),
              onChanged: (value) {
                name = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Adres'),
              onChanged: (value) {
                address = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Sözleşme Süresi (Yıl)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                contractDuration = int.tryParse(value) ?? 0;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Telefon Numarası'),
              onChanged: (value) {
                phoneNumber = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Kira Miktarı'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                rentAmount = double.tryParse(value) ?? 0.0;
              },
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    startDate = picked;
                    startDateText = DateFormat('yyyy-MM-dd').format(startDate);
                  });
                }
              },
              child: Text(startDateText),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _insertTenant();
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
