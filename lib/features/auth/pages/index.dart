import 'package:flutter/material.dart';
import 'package:notfallbereit/features/auth/pages/login_page.dart';
import 'package:notfallbereit/features/auth/pages/register_page.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Index extends StatelessWidget {
  const Index({super.key});

  void _openLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _openRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFA8C3A0),

      appBar: AppBar(backgroundColor: const Color(0xFFA8C3A0), elevation: 0),

      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),

            child: SizedBox(
              width: screenWidth * 0.8,

              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.15),

                  // Title Login
                  AutoSizeText(
                    'NOTFALLBEREIT',
                    style: AppStyles.title,
                    maxLines: 1,
                    minFontSize: 34,
                  ),

                  SizedBox(height: screenHeight * 0.2),

                  ElevatedButton(
                    onPressed: () => _openLogin(context),
                    style: AppStyles.button,
                    child: Text('Anmelden', style: AppStyles.buttonText),
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  AutoSizeText(
                    'Noch kein Konto?',
                    style: AppStyles.label,
                    maxLines: 1,
                    minFontSize: 24,
                  ),

                  TextButton(
                    onPressed: () => _openRegister(context),

                    child: const Text(
                      'Registrieren',
                      style: AppStyles.labelUnderline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
