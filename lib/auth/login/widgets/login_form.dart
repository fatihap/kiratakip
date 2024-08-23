import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../classes/constants.dart';
import '../../../pages/mainPage.dart';
import '../../password_configuration/forget_password.dart';
import '../../signup/signup.dart';

class TLoginForm extends StatefulWidget {
  final String? email;

  const TLoginForm({Key? key, this.email}) : super(key: key);

  @override
  _TLoginFormState createState() => _TLoginFormState();
}

class _TLoginFormState extends State<TLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _rememberMe = true;
  bool _isLoading = false;  // Add this state variable

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

  Future<void> _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;  // Start loading
      });

      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      setState(() {
        _isLoading = false;  // Stop loading
      });

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

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            enabled: !_isLoading,  // Disable while loading
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.direct_right),
              labelText: TTexts.email,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'E-Mail is required';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Enter a valid E-Mail address';
              }
              return null;
            },
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          TextFormField(
            controller: _passwordController,
            enabled: !_isLoading,  // Disable while loading
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.password_check),
              labelText: TTexts.password,
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Iconsax.eye : Iconsax.eye_slash,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Geçerli Bir Şifre Giriniz';
              }
              return null;
            },
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields / 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                  ),
                  const Text(TTexts.rememberMe),
                ],
              ),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () => Get.to(() => const ForgetPassword()),
                child: const Text(TTexts.forgetPassword),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          _isLoading
              ? const CircularProgressIndicator()  // Show loading spinner
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _signIn,
                    child: const Text(TTexts.signIn),
                  ),
                ),
          const SizedBox(height: TSizes.spaceBtwSections),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _isLoading
                  ? null
                  : () => Get.to(() => const SignUpScreen()),
              child: const Text(TTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}
