import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String? _message;

  Future<void> register() async {

    setState(() {
      _loading = true;
      _message = null;
    });

    try {

      final response = await http.post(
        Uri.parse(
          'http://localhost:3000/api/auth/register',
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
          'Registrierung erfolgreich. UserId: $userId',
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
      appBar: AppBar(
        title: const Text('Registrieren'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-Mail',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Passwort',
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _loading ? null : register,
              child: const Text('Registrieren'),
            ),

            const SizedBox(height: 24),

            if (_message != null)
              Text(_message!),
          ],
        ),
      ),
    );
  }
}