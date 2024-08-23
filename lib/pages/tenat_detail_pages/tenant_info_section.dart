import 'package:flutter/material.dart';

class TenantInfoSection extends StatelessWidget {
  final Map<String, dynamic> tenantDetails;

  const TenantInfoSection({super.key, required this.tenantDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kiracı Bilgileri',
            ),
            const SizedBox(height: 8.0),
            _buildInfoRow('Adı', tenantDetails['tenant_name']),
            _buildInfoRow('Soyadı', tenantDetails['tenant_surname']),
            _buildInfoRow('Adres', tenantDetails['address']),
            _buildInfoRow('Telefon', tenantDetails['phone']),
            _buildInfoRow('Kira Tutarı', '${tenantDetails['rent_amount']} TL'),
            _buildInfoRow('Sözleşme Süresi', '${tenantDetails['contract_duration']} ay'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value ?? 'Bilgi mevcut değil'),
          ),
        ],
      ),
    );
  }
}
