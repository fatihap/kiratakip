import 'package:flutter/material.dart';

import '../../classes/tenant_class.dart';

class ReusableTenantOptionsDialog extends StatelessWidget {
  final Tenant tenant;
  final VoidCallback onArchive;
  final VoidCallback onUnarchive;
  final VoidCallback onDelete;
  
  const ReusableTenantOptionsDialog({super.key, 
    required this.tenant,
    required this.onArchive,
    required this.onUnarchive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 16,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9, 
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kiracı İşlemleri',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${tenant.name} adlı kiracı için işlem seçin:',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding:const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('İptal'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 8),
              //  if (!tenant.isArchived)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Arşivle'),
                      onPressed: () {
                        onArchive();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
              //  if (tenant.isArchived)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Arşivden Çıkar'),
                      onPressed: () {
                        onUnarchive();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding:const  EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Sil'),
                    onPressed: () {
                      onDelete();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
