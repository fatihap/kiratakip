import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kiratakip/auth/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/constants.dart';
import '../widgets/addTenantPage/add_tenant_page.dart';
import 'tenant_card.dart';
import 'tenat_detail_pages/tenant_detail_page.dart';

class TenantListPage extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;

  const TenantListPage({Key? key, required this.token, required this.user})
      : super(key: key);

  @override
  _TenantListPageState createState() => _TenantListPageState();
}

class _TenantListPageState extends State<TenantListPage>
    with SingleTickerProviderStateMixin {
  List<dynamic> currentTenants = [];
  List<dynamic> archivedTenants = [];
  bool isLoading = true;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    fetchTenants();
  }

  Future<void> fetchTenants() async {
    final response = await http.get(
      Uri.parse('${Constants.apiUrl}/tenant?page=1'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final allTenants = data['payload'] ?? [];
      setState(() {
        currentTenants =
            allTenants.where((tenant) => tenant['is_archived'] == '0').toList();
        archivedTenants =
            allTenants.where((tenant) => tenant['is_archived'] == '1').toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to load tenants: ${response.reasonPhrase}')),
      );
    }
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void navigateToAddTenantPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTenantPage(
          onTenantAdded: (tenant) {
            fetchTenants();
          },
          token: widget.token,
          tenant: null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Tenants List'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: logOut,
              ),
            ],
            bottom: TabBar(
              controller: tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3.0,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'Current Tenants'),
                Tab(text: 'Archived Tenants'),
              ],
            ),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: tabController,
                  children: [
                    _buildTenantGrid(currentTenants),
                    _buildTenantGrid(archivedTenants),
                  ],
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: navigateToAddTenantPage,
            backgroundColor: Colors.teal,
            child: const Icon(Icons.add),
          )),
    );
  }

  Widget _buildTenantGrid(List<dynamic> tenants) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 3 / 2,
        ),
        itemCount: tenants.length,
        itemBuilder: (context, index) {
          final tenant = tenants[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TenantDetailPage(
                    token: widget.token,
                    tenantId: tenant['tenant_id'],
                  ),
                ),
              );
            },
            child: TenantCard(
              tenantName: tenant['tenant_name'] ?? 'N/A',
              tenantSurname: tenant['tenant_surname'] ?? 'N/A',
              tenantAddress: tenant['tenant_address'] ?? 'N/A',
              tenantPhone: tenant['tenant_phone'] ?? 'N/A',
              rentAmount: tenant['rent_amount']?.toString() ?? 'N/A',
              //bunu ayarlıcaz
              tenantType: 2,
            ),
          );
        },
      ),
    );
  }
}
