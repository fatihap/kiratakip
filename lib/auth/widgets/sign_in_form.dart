import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../classes/constants.dart';
import '../../pages/mainPage.dart';
import '../sign_up.dart';

class SignInForm extends StatefulWidget {
  final String? email;

  const SignInForm({Key? key, this.email}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    if (widget.email != null) {
      _emailController.text = widget.email!;
    }
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final user = {
        'email': prefs.getString('email'),
        'name': prefs.getString('name'),
        'surname': prefs.getString('surname'),
        'phone': prefs.getString('phone'),
        'user_id': prefs.getInt('user_id'),
        'is_premium': prefs.getBool('is_premium'),
        'is_synced': prefs.getBool('is_synced'),
      };

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(user: user, token: token),
        ),
      );
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  Future<void> _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = responseData['token'];
        final user = responseData['user'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('email', user['email']);
        await prefs.setString('name', user['name']);
        await prefs.setString('surname', user['surname']);
        await prefs.setString('phone', user['phone']);
        await prefs.setInt('user_id', user['user_id']);
        await prefs.setBool('is_premium', user['is_premium'] == '1');
        await prefs.setBool('is_synced', user['is_synced'] == '1');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Giriş başarılı'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(user: user, token: token),
          ),
        );
      } else {
        String errorMessage = 'Giriş başarısız.';
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Kira Takip',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Giriş Yap',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Kira takibi hiç bu kadar kolay olmadı',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Henüz üyeliğiniz yoksa ',
                  style: TextStyle(fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()),
                    );
                  },
                  child: const Text(
                    'üye olun.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'E-mail gerekli';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Geçerli bir e-mail adresi girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Şifre gerekli';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _signIn,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Giriş Yap',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                },
                child: const Text(
                  'Şifremi Unuttum?',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
