import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class TenantInfoPage extends StatelessWidget {
  final Map<String, dynamic> tenantDetails;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const TenantInfoPage({
    super.key,
    required this.tenantDetails,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiracı Bilgileri'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(
              icon: Icons.person,
              label: 'Adı',
              value: tenantDetails['tenant_name'],
            ),
            _buildInfoCard(
              icon: Icons.person_outline,
              label: 'Soyadı',
              value: tenantDetails['tenant_surname'],
            ),
            _buildInfoCard(
              icon: Icons.home,
              label: 'Adres',
              value: tenantDetails['address'],
            ),
            _buildInfoCard(
              icon: Icons.phone,
              label: 'Telefon',
              value: tenantDetails['phone'],
            ),
            _buildInfoCard(
              icon: Icons.attach_money,
              label: 'Kira Tutarı',
              value: '${tenantDetails['rent_amount']} TL',
            ),
            _buildInfoCard(
              icon: Icons.calendar_today,
              label: 'Sözleşme Süresi',
              value: '${tenantDetails['contract_duration']} ay',
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.teal,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.edit),
            label: 'Düzenle',
            onTap: onEditTap,
          ),
          SpeedDialChild(
            child: const Icon(Icons.delete),
            label: 'Sil',
            backgroundColor: Colors.red,
            onTap: onDeleteTap,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String label, required String? value}) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    value ?? 'Bilgi mevcut değil',
                    style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
