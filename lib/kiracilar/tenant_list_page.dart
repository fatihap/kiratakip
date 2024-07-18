import 'package:flutter/material.dart';

import '../classes/tenant_class.dart';
import '../helpers/dbhelper.dart';
import 'add_tenant_page.dart';
import 'rent_payment_page.dart';

class TenantListPage extends StatefulWidget {
  const TenantListPage({super.key});

  @override
  _TenantListPageState createState() => _TenantListPageState();
}

class _TenantListPageState extends State<TenantListPage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<Tenant> tenants = [];
  List<Tenant> filteredTenants = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateTenantList();
    searchController.addListener(filterTenants);
  }

  void updateTenantList() async {
    tenants = await dbHelper.getTenantList();
    filteredTenants = tenants;
    setState(() {});
  }

  void filterTenants() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredTenants = tenants.where((tenant) {
        return tenant.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> deleteTenant(Tenant tenant) async {
    await dbHelper.deleteTenant(tenant.id!);
    updateTenantList();
  }

  void showDeleteConfirmationDialog(Tenant tenant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kiracıyı Sil'),
          content: Text('${tenant.name} adlı kiracıyı silmek istediğinize emin misiniz?'),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sil'),
              onPressed: () {
                deleteTenant(tenant);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiracı Listesi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Kiracı Ara',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredTenants.length,
                itemBuilder: (BuildContext context, int index) {
                  final tenant = filteredTenants[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RentPaymentPage(tenant: tenant),
                          ),
                        ).then((_) {
                          updateTenantList();
                        });
                      },
                      onLongPress: () {
                        showDeleteConfirmationDialog(tenant);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tenant.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Adres: ${tenant.address}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTenant = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTenantPage(),
            ),
          );
          if (newTenant != null) {
            await dbHelper.insertTenant(newTenant);
            updateTenantList();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
