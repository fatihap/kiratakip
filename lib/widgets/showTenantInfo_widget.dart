// ignore: file_names
import 'package:flutter/material.dart';

import '../classes/tenant_class.dart';
import '../helpers/dbhelper.dart';
import '../kiracilar/update_tenant_widget.dart';

class TenantInfoPage extends StatelessWidget {
  final Tenant tenant;

  const TenantInfoPage({super.key, required this.tenant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiracı Bilgileri'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditTenantPage(tenant: tenant)),
              );
              if (result == true) {
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Onay'),
                  content: const Text('Kiracıyı silmek istediğinize emin misiniz?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Hayır'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Evet'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await DatabaseHelper.instance.deleteTenant(tenant.id!);
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Adı Soyadı: ${tenant.name}'),
            Text('Adres: ${tenant.address}'),
            Text('Kontrat Süresi: ${tenant.contractDuration}'),
            Text('Telefon Numarası: ${tenant.phoneNumber}'),
            Text('Kira Miktarı: ${tenant.rentAmount} TL'),
          ],
        ),
      ),
    );
  }
}
