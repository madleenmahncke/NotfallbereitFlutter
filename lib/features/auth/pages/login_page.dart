import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/features/emergency_profile/pages/create_emergency_profile.dart';
import 'package:notfallbereit/features/emergency_profile/pages/emergency_profile.dart';
import 'package:notfallbereit/footer/pages/legal_notice.dart';
import 'package:notfallbereit/footer/pages/privacy_policy.dart';
import 'package:notfallbereit/footer/pages/video_to_app.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../core/api/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // sends the login request
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

      if (response.statusCode == 200) {
        final bool hasEmergencyProfile = data['hasEmergencyProfile'];
        final int userId = data['userId'];
        final int? emergencyProfileId = data['emergencyProfileId'];
        final String token = data['token'];

        await storage.write(key: "jwt", value: token);

        // ensure widget is still in the widget tree
        if (!mounted) return;

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
            MaterialPageRoute(builder: (_) => CreateEmergencyProfilePage()),
          );
        }

        // shows a success or error message
        showSnackBar(data["message"], error: response.statusCode >= 400);
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

  void _openLegalNotice(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LegalNoticePage()),
    );
  }

  void _openVideoToAppPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VideoToAppPage()),
    );
  }

  void _openPrivacyPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
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

                  AutoSizeText(
                    'E-Mail:',
                    style: AppStyles.label,
                    maxLines: 1,
                    minFontSize: 24,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  TextField(
                    controller: _emailController,
                    maxLength: 255,
                    style: AppStyles.inputStyle,
                    decoration: AppStyles.textField('Hier E-Mail eingeben...'),
                  ),

                  SizedBox(height: screenHeight * 0.07),

                  AutoSizeText(
                    'Passwort:',
                    style: AppStyles.label,
                    maxLines: 1,
                    minFontSize: 24,
                  ),

                  SizedBox(height: screenHeight * 0.02),

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

      bottomNavigationBar: SafeArea(
        child: screenWidth < 1100
            ? _buildMobileLayout(context)
            : _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(
            style: AppStyles.footerButton,
            onPressed: () => _openLegalNotice(context),
            child: const Text("Impressum"),
          ),

          SizedBox(height: screenHeight * 0.02),

          ElevatedButton(
            style: AppStyles.footerVideoButton,
            onPressed: () => _openVideoToAppPage(context),
            child: const Text("Video zur App"),
          ),

          SizedBox(height: screenHeight * 0.02),

          OutlinedButton(
            style: AppStyles.footerButton,
            onPressed: () => _openPrivacyPage(context),
            child: const Text("Datenschutzerklärung"),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            style: AppStyles.footerButton,
            onPressed: () => _openLegalNotice(context),
            child: const Text("Impressum"),
          ),

          ElevatedButton(
            style: AppStyles.footerVideoButton,
            onPressed: () => _openVideoToAppPage(context),
            child: const Text("Video zur App"),
          ),

          OutlinedButton(
            style: AppStyles.footerButton,
            onPressed: () => _openPrivacyPage(context),
            child: const Text("Datenschutzerklärung"),
          ),
        ],
      ),
    );
  }
}
