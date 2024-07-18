import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // intl paketinden tarih formatlama için gerekli

import 'kiracilar/tenant_list_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Landlord App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TenantListPage(), // Ana sayfa kiracı listesi sayfası olacak
    );
  }
}
