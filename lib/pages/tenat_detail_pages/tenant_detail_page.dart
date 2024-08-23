import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kiratakip/classes/constants.dart';

import 'edit_tenant.dart';
import 'payment_list.dart';
import 'tenant_detail_header.dart';
import 'tenant_info_section.dart';

class TenantDetailPage extends StatefulWidget {
  final String token;
  final int tenantId;

  const TenantDetailPage(
      {super.key, required this.token, required this.tenantId});

  @override
  _TenantDetailPageState createState() => _TenantDetailPageState();
}

class _TenantDetailPageState extends State<TenantDetailPage> {
  Map<String, dynamic>? tenantDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTenantDetails();
  }

  Future<void> fetchTenantDetails() async {
    final response = await http.get(
      Uri.parse('${Constants.apiUrl}/tenant/${widget.tenantId}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print('Tenant Details: $data'); // Debugging line
      setState(() {
        tenantDetails = data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Kiracı bilgileri yüklenemedi: ${response.reasonPhrase}')),
      );
    }
  }

  String formatDate(String date) {
    try {
      final dateTime = DateTime.parse(date);
      return DateFormat('MMMM yyyy', 'tr_TR').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  void _showPaymentDialog(int index) {
    final payment = tenantDetails!['payments'][index];
    final DateTime startDate = DateTime.parse(tenantDetails!['start_date']);
    final DateTime paymentDate =
        DateTime(startDate.year, startDate.month + index);
    final paymentMonth = DateFormat('MMMM yyyy', 'tr_TR').format(paymentDate);

    final TextEditingController amountController =
        TextEditingController(text: payment['amount'].toString());
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$paymentMonth Ödeme Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Mevcut Tutar: ${payment['amount']} TL'),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Yeni Tutar',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Text(
                    'Tarih Seç: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                _updatePaymentAmount(
                    index, amountController.text, selectedDate);
                Navigator.of(context).pop();
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteTenant() async {
    final response = await http.delete(
      Uri.parse('${Constants.apiUrl}/tenant/${widget.tenantId}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pop(); // Kiracı listesine geri dön
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kiracı başarıyla silindi')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silinemedi: ${response.reasonPhrase}')),
      );
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kiracıyı Sil'),
          content:
              const Text('Bu kiracıyı silmek istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteTenant();
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditTenantPage() {
    // Düzenleme sayfasına yönlendirme
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTenantPage(
          token: widget.token,
          tenantId: widget.tenantId,
          tenantDetails: tenantDetails,
        ),
      ),
    );
  }

  Future<void> _updatePaymentAmount(
      int index, String newAmount, DateTime paymentDate) async {
    final payment = tenantDetails!['payments'][index];
    final paymentId = payment['id'];
    final DateTime startDate = DateTime.parse(tenantDetails!['start_date']);
    final DateTime paymentDateAdjusted =
        DateTime(startDate.year, startDate.month + index);
    final String paymentDateStr = DateFormat('yyyy-MM-dd').format(paymentDate);

    final String formattedAmount = newAmount.replaceAll(RegExp(r'[^\d]'), '');
    final int month = paymentDateAdjusted.month;

    final response = await http.post(
      Uri.parse('${Constants.apiUrl}/payment'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'tenant_id': widget.tenantId,
        'month': month,
        'amount': formattedAmount,
        'payment_date': paymentDateStr,
        'is_paid': 1,
        'paid_amount': formattedAmount,
      }),
    );

    if (response.statusCode == 200) {
      fetchTenantDetails();
    } else {
      final responseBody = jsonDecode(response.body);
      final errors = responseBody['errors'] ?? [];
      final errorMessage = errors.join(', ');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ödeme güncellenemedi: $errorMessage')),
      );
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Kiracı Detayları'),
        actions: [
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TenantInfoPage(
                  tenantDetails: tenantDetails!,
                  onEditTap: _navigateToEditTenantPage,
                  onDeleteTap: _showDeleteConfirmationDialog,
                ),
              ),
            );
          },
        ),
      ],
    ),
    
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : tenantDetails == null
            ? const Center(child: Text('Bilgi mevcut değil'))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TenantDetailHeader(
                        tenantName:
                            '${tenantDetails!['tenant_name']} ${tenantDetails!['tenant_surname']}',
                        payments: tenantDetails!['payments'] as List,
                        onPaymentTap: _showPaymentDialog,
                      ),
                      const SizedBox(height: 16.0),
                      PaymentList(
                        payments: tenantDetails!['payments'] as List,
                        startDate: tenantDetails!['start_date'],
                        onPaymentTap: _showPaymentDialog,
                      ),
                    ],
                  ),
                ),
              ),
   
  );
}

}
