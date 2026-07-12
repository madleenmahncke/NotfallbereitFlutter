import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/features/emergency_profile/pages/create_emergency_profile.dart';
import 'package:notfallbereit/features/emergency_profile/pages/emergency_profile.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../core/api/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProfilePage extends StatefulWidget {
  final int emergencyProfileId;
  const UserProfilePage({super.key, required this.});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
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
                onPressed: () => {},
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
              constraints: const BoxConstraints(maxWidth: 1100),
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

                  SizedBox(
                    height: 500,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// LINKE SEITE
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.folder_shared_outlined, size: 32),
                                  SizedBox(width: 10),
                                  Text(
                                    "Notfallmappendaten:",
                                    style: AppStyles.tableTitleUnderlined,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 40),

                              _profileEntry("Vorname", "Max"),
                              _profileEntry("Nachname", "Mustermann"),
                              _profileEntry(
                                "Straße und Hausnummer",
                                "Musterstraße 11",
                              ),
                              _profileEntry(
                                "Postleitzahl und Ort",
                                "12345 Musterhausen",
                              ),

                              const Spacer(),

                              Center(
                                child: SizedBox(
                                  width: 240,
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
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 500,
                          child: VerticalDivider(thickness: 2),
                        ),

                        /// RECHTE SEITE
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.person_outline, size: 32),
                                    SizedBox(width: 10),
                                    Text(
                                      "Anmeldedaten:",
                                      style: AppStyles.tableTitleUnderlined,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 40),

                                _profileEntry(
                                  "E-Mail",
                                  "max.mustermann@mustermail.de",
                                ),

                                _profileEntry("Passwort", "****"),

                                const Spacer(),

                                Center(
                                  child: SizedBox(
                                    width: 220,
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
                              ],
                            ),
                          ),
                        ),
                      ],
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
