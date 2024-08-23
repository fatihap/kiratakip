import 'package:flutter/material.dart';

class TenantCard extends StatelessWidget {
  final String tenantName;
  final String tenantSurname;
  final String tenantAddress;
  final String tenantPhone;
  final String rentAmount;
  final int tenantType;

  const TenantCard({
    required this.tenantName,
    required this.tenantSurname,
    required this.tenantAddress,
    required this.tenantPhone,
    required this.rentAmount,
    required this.tenantType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '$tenantName $tenantSurname',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  tenantType == 1
                      ? Icons.home
                      : Icons.store, 
                  color: Colors.blueAccent,
                  size: 40,
                ),
              ],
            ),
            const SizedBox(height: 12),
            TenantDetailText(
              label: 'Adres',
              value: tenantAddress,
            ),
            TenantDetailText(
              label: 'Kira Miktarı',
              value: rentAmount,
            ),
          ],
        ),
      ),
    );
  }
}

class TenantDetailText extends StatelessWidget {
  final String label;
  final String value;

  const TenantDetailText({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: const TextStyle(
            color: Color.fromARGB(255, 109, 86, 86),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
