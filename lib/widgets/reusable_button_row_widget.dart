import 'package:flutter/material.dart';

class ReusableButtonRow extends StatelessWidget {
  final Function() showTenantInfo;
  const ReusableButtonRow({super.key, 
    required this.showTenantInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: showTenantInfo,
          child: const Text('Kiracı Bilgileri'),
        ),
       
      ],
    );
  }
}
