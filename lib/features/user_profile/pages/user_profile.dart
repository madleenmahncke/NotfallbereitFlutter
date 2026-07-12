import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/features/auth/pages/index.dart';
import 'package:notfallbereit/features/alert/pages/custom_alert.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../core/api/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProfilePage extends StatefulWidget {
  final Map<String, dynamic>? emergencyProfile;

  const UserProfilePage({super.key, required this.emergencyProfile});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String eMail = "";
  int userId = 00;

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final token = await storage.read(key: "jwt");

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/user/getUser'),
        headers: {"Authorization": "Bearer $token"},
      );

      final data = jsonDecode(response.body);

      setState(() {
        eMail = data['eMail'];
        userId = data['userId'];
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteUserProfile() async {
    try {
      final token = await storage.read(key: "jwt");

      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/api/user/$userId'),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Index()),
        );

        debugPrint('Benutzer erfolgreich gelöscht. UserId: $userId');
      }
    } catch (e) {
      debugPrint(e.toString());
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
        toolbarHeight: 80,

        automaticallyImplyLeading: false,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 180,
              height: 56,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF666666),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
                label: const Text('Zurück', style: AppStyles.appBarText),
              ),
            ),

            SizedBox(
              width: 180,
              height: 56,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 204, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => CustomAlert(
                      title: 'WARNUNG',
                      message: 'Willst du dein Nutzerprofil wirklich löschen?',
                      onConfirm: () => deleteUserProfile(),
                    ),
                  );
                },
                child: const AutoSizeText(
                  minFontSize: 20,
                  'Profil löschen',
                  style: AppStyles.buttonText,
                ),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenWidth),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05),

                  AutoSizeText(
                    'PROFILDATEN',
                    style: AppStyles.title,
                    maxLines: 1,
                    minFontSize: 34,
                  ),

                  SizedBox(height: screenHeight * 0.08),

                  if (screenWidth < 1100)
                    _buildMobileLayout(context)
                  else
                    _buildDesktopLayout(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _leftColumn(BuildContext context, {required bool desktop}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.07),

        Row(
          children: const [
            Icon(Icons.folder_shared_outlined, size: 32),
            SizedBox(width: 10),
            Text("Notfallmappendaten:", style: AppStyles.tableTitleUnderlined),
          ],
        ),

        SizedBox(height: screenHeight * 0.05),

        _profileEntry("Vorname", widget.emergencyProfile!['first_name']),

        _profileEntry("Nachname", widget.emergencyProfile!['last_name']),

        _profileEntry(
          "Straße und Hausnummer",
          widget.emergencyProfile!['street'],
        ),

        _profileEntry(
          "Postleitzahl und Ort",
          widget.emergencyProfile!['zip_code'],
        ),

        // because Spacer() doesn't work on mobile
        if (desktop) const Spacer() else const SizedBox(height: 40),

        Center(
          child: SizedBox(
            width: desktop ? screenWidth * 0.3 : screenWidth * 0.6,
            child: ElevatedButton(
              style: AppStyles.button,
              onPressed: () {},
              child: const Text(
                "NOTFALLMAPPENDATEN\nändern",
                textAlign: TextAlign.center,
                style: AppStyles.buttonText,
              ),
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.07),
      ],
    );
  }

  Widget _rightColumn(BuildContext context, {required bool desktop}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.07),

        Row(
          children: const [
            Icon(Icons.person_outline, size: 32),
            SizedBox(width: 10),
            Text("Anmeldedaten:", style: AppStyles.tableTitleUnderlined),
          ],
        ),

        SizedBox(height: screenHeight * 0.05),

        _profileEntry("E-Mail", eMail),

        _profileEntry("Passwort", "****"),

        // because Spacer() doesn't work on mobile
        if (desktop) const Spacer() else const SizedBox(height: 40),

        Center(
          child: SizedBox(
            width: desktop ? screenWidth * 0.3 : screenWidth * 0.6,
            child: ElevatedButton(
              style: AppStyles.button,
              onPressed: () {},
              child: const Text(
                "ANMELDEDATEN\nändern",
                textAlign: TextAlign.center,
                style: AppStyles.buttonText,
              ),
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.07),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          _leftColumn(context, desktop: false),

          const Divider(thickness: 2, color: Color(0xFF20124D)),

          _rightColumn(context, desktop: false),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SizedBox(
      height: 600,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _leftColumn(context, desktop: true)),

          const VerticalDivider(
            width: 40,
            thickness: 2,
            color: Color(0xFF20124D),
          ),

          Expanded(child: _rightColumn(context, desktop: true)),
        ],
      ),
    );
  }

  Widget _profileEntry(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35),
      child: RichText(
        text: TextSpan(
          style: AppStyles.text,
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
