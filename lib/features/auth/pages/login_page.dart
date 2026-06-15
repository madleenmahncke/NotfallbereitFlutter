import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/theme/app_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String? _message;

  Future<void> login() async {
    setState(() {
      _loading = true;
      _message = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      setState(() {
        _message = data['message'];
      });

      if (response.statusCode == 200) {
        final userId = data['id'];

        debugPrint('Login erfolgreich. UserId: $userId');

        // TODO:
        // JWT speichern
        // Zur HomePage navigieren
      }
    } catch (e) {
      setState(() {
        _message = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _openEmergencyProfile(BuildContext context) {
    // TODO!!!
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFA8C3A0),

      appBar: AppBar(
        backgroundColor: const Color(0xFFA8C3A0),
        elevation: 0,

        leadingWidth: 120,

        leading: TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Color(0xFF20124D)),
          label: const Text('Zurück', style: AppStyles.label),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),

          child: SizedBox(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.1),

                // Title
                Text('ANMELDUNG', style: AppStyles.title),

                SizedBox(height: screenHeight * 0.1),

                // Label E-Mail
                Text('E-Mail:', style: AppStyles.label),

                SizedBox(height: screenHeight * 0.02),

                // TextField E-Mail
                TextField(
                  style: AppStyles.inputStyle,
                  decoration: AppStyles.textField('E-Mail'),
                ),

                SizedBox(height: screenHeight * 0.07),

                Text('Passwort:', style: AppStyles.label),

                SizedBox(height: screenHeight * 0.02),

                TextField(
                  style: AppStyles.inputStyle,
                  decoration: AppStyles.textField('E-Mail'),
                ),

                SizedBox(height: screenHeight * 0.08),

                ElevatedButton(
                  onPressed: () => _openEmergencyProfile,
                  style: AppStyles.button,
                  child: Text('Anmelden', style: AppStyles.buttonText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
