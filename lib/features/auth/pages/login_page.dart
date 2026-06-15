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
        Uri.parse(
          'http://localhost:3000/api/auth/login',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
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

        debugPrint(
          'Login erfolgreich. UserId: $userId',
        );

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

  @override
  Widget build(BuildContext context) {
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
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF20124D),
          ),
          label: const Text(
            'Zurück',
            style: TextStyle(
              color: Color(0xFF20124D),
            ),
          ),
        ),
      ),

      body: Center(
        child: SizedBox(
          child: Column(
            children: [
              // Title
              Text('ANMELDUNG', style: AppStyles.title),

              // Label E-Mail
              Text(
                'E-Mail',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF20124D),
                  ),
              ),

              // TextField E-Mail
              TextField(

              ),
              TextField(),
              //ElevatedButton()
            ],
          )
        ), 
      ),
    );
  }
}