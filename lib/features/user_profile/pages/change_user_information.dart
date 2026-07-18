import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/features/user_profile/pages/user_profile.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../core/api/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangeUserInformationPage extends StatefulWidget {
  final Map<String, dynamic>? emergencyProfile;
  final String eMail;

  const ChangeUserInformationPage({
    super.key,
    required this.emergencyProfile,
    required this.eMail,
  });

  @override
  State<ChangeUserInformationPage> createState() =>
      _ChangeUserInformationPageState();
}

class _ChangeUserInformationPageState extends State<ChangeUserInformationPage> {
  var _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatedPasswordController = TextEditingController();

  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasNumber = false;
  bool hasSpecial = false;

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // initialize text fields
  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: widget.eMail);
  }

  // sends the changed user information request
  Future<void> changeUserInformation() async {
    try {
      final token = await storage.read(key: "jwt");

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/api/user/updateUser'),
        headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
          'repeatedPassword': _repeatedPasswordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      // shows a success or error message
      showSnackBar(data["message"], error: response.statusCode >= 400);

      if (response.statusCode == 200) {
        // ensure widget is still in the widget tree
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => UserProfilePage(
              emergencyProfileId: widget.emergencyProfile!['id'],
            ),
          ),
        );
      }
    } catch (e) {
      showSnackBar(
        "Es ist ein unerwarteter Fehler aufgetreten. + $e",
        error: true,
      );
    }
  }

  // validates password requirements by ChatGPT
  void checkPassword(String password) {
    setState(() {
      hasMinLength = password.length >= 12;
      hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
      hasLowercase = RegExp(r'[a-z]').hasMatch(password);
      hasNumber = RegExp(r'\d').hasMatch(password);
      hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    });
  }

  // builds a password requirement row
  Widget passwordRequirement(String text, bool fulfilled) {
    return Row(
      children: [
        Icon(
          fulfilled ? Icons.check_circle : Icons.cancel,
          color: fulfilled
              ? const Color(0xFF274E13)
              : const Color.fromARGB(255, 204, 0, 0),
          size: 18,
        ),
        const SizedBox(width: 8),
        AutoSizeText(text, minFontSize: 18),
      ],
    );
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => UserProfilePage(
                    emergencyProfileId: widget.emergencyProfile!['id'],
                  ),
                ),
              );
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
                    'NUTZERDATEN ÄNDERN',
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
                    onChanged: checkPassword,
                    obscureText: true,
                    style: AppStyles.inputStyle,
                    decoration: AppStyles.textField(
                      'Hier Passwort eingeben...',
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.07),

                  AutoSizeText(
                    'Passwort wiederholen:',
                    style: AppStyles.label,
                    maxLines: 1,
                    minFontSize: 24,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  TextField(
                    controller: _repeatedPasswordController,
                    obscureText: true,
                    style: AppStyles.inputStyle,
                    decoration: AppStyles.textField(
                      'Hier Passwort wiederholen...',
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Das Passwort muss erfüllen: ",
                        minFontSize: 19,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      passwordRequirement(
                        "Mindestens 12 Zeichen",
                        hasMinLength,
                      ),

                      passwordRequirement(
                        "Mindestens ein Großbuchstabe",
                        hasUppercase,
                      ),

                      passwordRequirement(
                        "Mindestens ein Kleinbuchstabe",
                        hasLowercase,
                      ),

                      passwordRequirement("Mindestens eine Zahl", hasNumber),

                      passwordRequirement(
                        "Mindestens ein Sonderzeichen",
                        hasSpecial,
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.08),

                  ElevatedButton(
                    onPressed: () => changeUserInformation(),
                    style: AppStyles.button,
                    child: Text(
                      'Bearbeiten',
                      style: AppStyles.buttonText,
                      textAlign: TextAlign.center,
                    ),
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
