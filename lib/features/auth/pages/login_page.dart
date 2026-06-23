import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/features/emergency_profile/pages/create_emergency_profile.dart';
import 'package:notfallbereit/features/emergency_profile/pages/emergency_profile.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../core/api/api_config.dart';

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
        Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
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
        final bool hasEmergencyProfile = data['hasEmergencyProfile'];
        final int userId = data['userId'];
        final int? emergencyProfileId = data['emergencyProfileId'];

        if (hasEmergencyProfile) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => EmergencyProfilePage(
                userId: userId,
                emergencyProfileId: emergencyProfileId!,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => CreateEmergencyProfilePage(userId: userId),
            ),
          );
        }
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFA8C3A0),

      appBar: AppBar(
        backgroundColor: const Color(0xFFA8C3A0),
        elevation: 0,
        leadingWidth: 180,

        leading: Padding(
          padding: const EdgeInsets.only(left: 12, top: 12),
          child: TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF666666),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            label: const Text('Zurück', style: AppStyles.appBarText),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),

            child: SizedBox(
              width: screenWidth * 0.8,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.1),

                  // Title Login
                  AutoSizeText(
                    'ANMELDUNG',
                    style: AppStyles.title,
                    maxLines: 1,
                    minFontSize: 34,
                  ),

                  SizedBox(height: screenHeight * 0.1),

                  // Label E-Mail
                  AutoSizeText(
                    'E-Mail:',
                    style: AppStyles.label,
                    maxLines: 1,
                    minFontSize: 24,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // TextField E-Mail
                  TextField(
                    controller: _emailController,
                    style: AppStyles.inputStyle,
                    decoration: AppStyles.textField('Hier E-Mail eingeben...'),
                  ),

                  SizedBox(height: screenHeight * 0.07),

                  // Label Password
                  AutoSizeText(
                    'Passwort:',
                    style: AppStyles.label,
                    maxLines: 1,
                    minFontSize: 24,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // TextField Password
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: AppStyles.inputStyle,
                    decoration: AppStyles.textField(
                      'Hier Passwort eingeben...',
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.08),

                  ElevatedButton(
                    onPressed: () => login(),
                    style: AppStyles.button,
                    child: Text('Anmelden', style: AppStyles.buttonText),
                  ),

                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
