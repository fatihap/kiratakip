import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double monthlyIncome = 5000.00; // Aylık kazanç
    final int numberOfRentedProperties = 10; // Kiradaki ev sayısı
    final double annualIncome = monthlyIncome * 12; // Yıllık kazanç

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Kullanıcı Bilgileri'),
              _buildUserInfoTile('E-mail', user['email'] ?? 'N/A'),
              _buildUserInfoTile('Ad', user['name'] ?? 'N/A'),
              _buildUserInfoTile('Soyad', user['surname'] ?? 'N/A'),
              _buildUserInfoTile('Telefon', user['phone'] ?? 'N/A'),
              _buildUserInfoTile(
                  'Kullanıcı ID', user['user_id']?.toString() ?? 'N/A'),
              _buildUserInfoTile(
                  'Premium Üye', user['is_premium'] == true ? 'Evet' : 'Hayır'),
              _buildUserInfoTile(
                  'Senkronize', user['is_synced'] == true ? 'Evet' : 'Hayır'),
              const SizedBox(height: 32),

              // Finansal Bilgiler
              _buildSectionTitle('Finansal Bilgiler'),
              _buildFinancialInfoTile('Aylık Kazanç',
                  '₺${monthlyIncome.toStringAsFixed(2)}', Colors.green),
              _buildFinancialInfoTile('Kiradaki Ev Sayısı',
                  numberOfRentedProperties.toString(), Colors.blue),
              _buildFinancialInfoTile('Yıllık Kazanç',
                  '₺${annualIncome.toStringAsFixed(2)}', Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  // Bölüm başlığı widget'ı
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  // Kullanıcı bilgilerini gösteren widget
  Widget _buildUserInfoTile(String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildFinancialInfoTile(String title, String value, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
