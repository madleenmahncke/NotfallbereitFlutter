import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/features/unbenannt/pages/auswahl_informationen.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../core/api/api_config.dart';
import '../../allergy/pages/allergy_dialog.dart';

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

  //bool _loading = false;
  //String? _message;

  @override
  void initState() {
    super.initState();

    loadEmergencyProfile();
  }

  Future<void> loadEmergencyProfile() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/emergencyProfile/${widget.userId}/${widget.emergencyProfileId}',
        ),
      );

      final data = jsonDecode(response.body);

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

                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (screenWidth > 1300) {
                        return _buildDesktopLayout(context);
                      }

                      return _buildMobileLayout(context);
                    },
                  ),

                  _buildButtons(context),
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('› ${item['name']}', style: AppStyles.text),
                        ],
                      ),
                    );
                  }

                  if (title == 'Notfallkontakte:') {
                    return Text(
                      '› ${item['first_name']} ${item['last_name']}',
                      style: AppStyles.text,
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
                builder: (_) => SelectInformationWindow(title: 'ENTFERNEN', emergencyProfileId: widget.emergencyProfileId),
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
            onPressed: () {},
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
                builder: (_) => SelectInformationWindow(title: 'HINZUFÜGEN', emergencyProfileId: widget.emergencyProfileId),
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
                  builder: (_) => SelectInformationWindow(title: 'HINZUFÜGEN', emergencyProfileId: widget.emergencyProfileId),
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
              onPressed: () {},
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
                  builder: (_) => SelectInformationWindow(title: 'ENTFERNEN', emergencyProfileId: widget.emergencyProfileId),
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
