import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../core/api/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../pages/paramedic_verification_page.dart';

class ParamedicLoginPage extends StatefulWidget {
  const ParamedicLoginPage({super.key});

  @override
  State<ParamedicLoginPage> createState() => _ParamedicLoginPageState();
}

class _ParamedicLoginPageState extends State<ParamedicLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> login() async {
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

      // shows a success or error message
      showSnackBar(data["message"], error: response.statusCode >= 400);

      if (response.statusCode == 201) {
        final int paramedicId = data['userId'];
        final String token = data['token'];

        await storage.write(key: "jwt", value: token);

        if (data["role"] != "PARAMEDIC") {
          showSnackBar("Bitte kontaktieren Sie den Support.", error: true);

          return;
        } else {
          // ensure widget is still in the widget tree
          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ParamedicVerificationPage(paramedicId: paramedicId),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showSnackBar(String message, {bool error = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error
            ? const Color.fromARGB(255, 204, 0, 0)
            : const Color(0xFF274E13),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
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
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
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
                    maxLength: 255,
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
