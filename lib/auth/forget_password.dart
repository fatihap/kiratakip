import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TenantCard extends StatelessWidget {
  final String tenantName;
  final String tenantSurname;
  final String tenantAddress;
  final String tenantPhone;
  final String rentAmount;

  TenantCard({
    required this.tenantName,
    required this.tenantSurname,
    required this.tenantAddress,
    required this.tenantPhone,
    required this.rentAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 200, // Adjust max height as needed
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  FontAwesomeIcons.building,
                  color: Colors.blue,
                  size: 24.0,
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    '$tenantName $tenantSurname',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            _buildInfoRow('Address', tenantAddress),
            SizedBox(height: 8.0),
            _buildInfoRow('Phone', tenantPhone),
            SizedBox(height: 8.0),
            _buildInfoRow('Rent', '$rentAmount TL'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
