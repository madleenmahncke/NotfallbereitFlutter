import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/features/emergency_contact/pages/emergency_contact_dialog.dart';
import 'package:notfallbereit/features/medication/pages/medication_dialog.dart';
import 'package:notfallbereit/features/qr_code/pages/auswahl_informationen.dart';
import 'package:notfallbereit/features/qr_code/pages/qr_code_dialog.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../core/api/api_config.dart';
import '../../allergy/pages/allergy_dialog.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../user_profile/pages/user_profile.dart';

class EmergencyProfilePage extends StatefulWidget {
  final int userId;
  final int emergencyProfileId;

  const EmergencyProfilePage({
    super.key,
    required this.userId,
    required this.emergencyProfileId,
  });

  @override
  State<EmergencyProfilePage> createState() => _EmergencyProfilePageState();
}

class _EmergencyProfilePageState extends State<EmergencyProfilePage> {
  List<dynamic> allergies = [];
  List<dynamic> medications = [];
  List<dynamic> emergencyContacts = [];

  Map<String, dynamic>? emergencyProfile;

  final storage = const FlutterSecureStorage();

  // initialize emergency profile data
  @override
  void initState() {
    super.initState();

    loadEmergencyProfile();
  }

  // loads the emergency profile
  Future<void> loadEmergencyProfile() async {
    try {
      final token = await storage.read(key: "jwt");

      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/emergencyProfile/getEmergencyProfile/${widget.emergencyProfileId}',
        ),
        headers: {"Authorization": "Bearer $token"},
      );

      final data = jsonDecode(response.body);

      // shows a success or error message
      showSnackBar(data["message"], error: response.statusCode >= 400);

      setState(() {
        emergencyProfile = data['emergencyProfile'];
        allergies = data['allergies'] ?? [];
        medications = data['medications'] ?? [];
        emergencyContacts = data['emergencyContacts'] ?? [];
      });
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

    if (emergencyProfile == null) {
      return const Center(child: CircularProgressIndicator());
    }

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
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB74D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          UserProfilePage(emergencyProfileId: widget.emergencyProfileId),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.person_outline,
                  color: Colors.black87,
                  size: 24,
                ),
                label: const Text('Profil', style: AppStyles.label),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),

            child: SizedBox(
              width: screenWidth * 0.9,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.06),

                  // Title Create Emergency Profile
                  AutoSizeText(
                    'NOTFALLMAPPE',
                    style: AppStyles.title,
                    maxLines: 1,
                    minFontSize: 34,
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  AutoSizeText(
                    '${emergencyProfile!['first_name']} ${emergencyProfile!['last_name']}, ${emergencyProfile!['street_and_number']}, ${emergencyProfile!['location']}',
                    maxLines: 6,
                    minFontSize: 24,
                    style: AppStyles.label,
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (screenWidth > 1300) {
                        return _buildDesktopLayout(context);
                      }

                      return _buildMobileLayout(context);
                    },
                  ),

                  _buildButtons(context),

                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenHeight * 0.6,
      child: Row(
        children: [
          Expanded(child: _section('Allergien:', allergies, context)),

          SizedBox(width: screenWidth * 0.005),

          Expanded(child: _section('Medikamente:', medications, context)),

          SizedBox(width: screenWidth * 0.005),

          Expanded(
            child: _section('Notfallkontakte:', emergencyContacts, context),
          ),

          SizedBox(width: screenWidth * 0.005),

          Expanded(child: _section('Dokumente:', allergies, context)),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _section('Allergien:', allergies, context),

        const SizedBox(height: 20),

        _section('Medikamente:', medications, context),
        const SizedBox(height: 20),

        _section('Notfallkontakte:', emergencyContacts, context),
        const SizedBox(height: 20),

        _section('Dokumente:', allergies, context),
      ],
    );
  }

  Widget _section(String title, List<dynamic> entries, BuildContext context) {
    return Container(
      height: 250,

      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 15, 7, 42),
          width: 3,
        ),
      ),

      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),

            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(208, 15, 7, 42),
                  width: 1.5,
                ),
              ),
            ),

            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.tableTitleUnderlined,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final item = entries[index];

                  if (title == 'Allergien:') {
                    return TextButton(
                      onPressed: () async {
                        final result = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => AllergyDialog(allergy: item),
                        );

                        if (result == true) {
                          await loadEmergencyProfile();
                        }
                      },
                      child: Text(
                        '› ${item['allergen']}',
                        style: AppStyles.text,
                      ),
                    );
                  }

                  if (title == 'Medikamente:') {
                    return TextButton(
                      onPressed: () async {
                        final result = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => MedicationDialog(medication: item),
                        );

                        if (result == true) {
                          await loadEmergencyProfile();
                        }
                      },
                      child: Text('› ${item['name']}', style: AppStyles.text),
                    );
                  }

                  if (title == 'Notfallkontakte:') {
                    return TextButton(
                      onPressed: () async {
                        final result = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              EmergencyContactDialog(emergencyContact: item),
                        );

                        if (result == true) {
                          await loadEmergencyProfile();
                        }
                      },
                      child: Text(
                        '› ${item['first_name']} ${item['last_name']}',
                        style: AppStyles.text,
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 1300) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () async {
              final result = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => SelectInformationWindow(
                  title: 'ENTFERNEN',
                  emergencyProfileId: widget.emergencyProfileId,
                ),
              );

              if (result == true) {
                await loadEmergencyProfile();
              }
            },
            style: AppStyles.removeButton,
            child: AutoSizeText(
              'Information ENTFERNEN',
              style: AppStyles.emergencyProfileInformationButtonText,
              minFontSize: 24,
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              final result = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    QRCodeDialog(emergencyProfile: emergencyProfile!),
              );

              if (result == true) {
                await loadEmergencyProfile();
              }
            },
            style: AppStyles.qrCodeButton,
            child: AutoSizeText(
              'QR-Code abrufen',
              style: AppStyles.emergencyProfileInformationButtonText,
              minFontSize: 24,
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              final result = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => SelectInformationWindow(
                  title: 'HINZUFÜGEN',
                  emergencyProfileId: widget.emergencyProfileId,
                ),
              );

              if (result == true) {
                await loadEmergencyProfile();
              }
            },
            style: AppStyles.button,
            child: AutoSizeText(
              'Information HINZUFÜGEN',
              style: AppStyles.emergencyProfileInformationButtonText,
              minFontSize: 24,
            ),
          ),

          SizedBox(height: screenHeight * 0.05),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(height: screenHeight * 0.1),

          SizedBox(
            width: 600,
            child: ElevatedButton(
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => SelectInformationWindow(
                    title: 'HINZUFÜGEN',
                    emergencyProfileId: widget.emergencyProfileId,
                  ),
                );

                if (result == true) {
                  await loadEmergencyProfile();
                }
              },
              style: AppStyles.button,
              child: const Text(
                'Information HINZUFÜGEN',
                style: AppStyles.emergencyProfileInformationButtonText,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.05),

          SizedBox(
            width: 600,
            child: ElevatedButton(
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      QRCodeDialog(emergencyProfile: emergencyProfile!),
                );

                if (result == true) {
                  await loadEmergencyProfile();
                }
              },
              style: AppStyles.qrCodeButton,
              child: AutoSizeText(
                'QR-Code abrufen',
                style: AppStyles.emergencyProfileInformationButtonText,
                minFontSize: 24,
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.05),

          SizedBox(
            width: 600,
            child: ElevatedButton(
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => SelectInformationWindow(
                    title: 'ENTFERNEN',
                    emergencyProfileId: widget.emergencyProfileId,
                  ),
                );

                if (result == true) {
                  await loadEmergencyProfile();
                }
              },
              style: AppStyles.removeButton,
              child: const Text(
                'Information ENTFERNEN',
                style: AppStyles.emergencyProfileInformationButtonText,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.05),
        ],
      );
    }
  }
}
