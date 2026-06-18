import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../core/api/api_config.dart';

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
      
      print(response.statusCode);
      print(response.body);

      final data = jsonDecode(response.body);

      print('BODY: ${response.body}');
      print('ALLERGIES: ${data['allergies']}');

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
              width: screenWidth * 0.8,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.1),

                  // Title Create Emergency Profile
                  AutoSizeText(
                    'NOTFALLMAPPE',
                    style: AppStyles.title,
                    maxLines: 1,
                    minFontSize: 34,
                  ),

                  SizedBox(height: screenHeight * 0.1),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 900) {
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
      height: 500,
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
                    return Text('› ${item['allergen']}', style: AppStyles.text);
                  }

                  if (title == 'Medikamente:') {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${item['name']}, ', style: AppStyles.text),
                          Text('${item['dosage']}', style: AppStyles.text),
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

    if (screenWidth > 900) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: screenHeight * 0.05),

          ElevatedButton(
            onPressed: () {},
            style: AppStyles.removeButton,
            child: const Text(
              'Information ENTFERNEN',
              style: AppStyles.buttonText,
            ),
          ),

          ElevatedButton(
            onPressed: () {},
            style: AppStyles.button,
            child: const Text(
              'Information HINZUFÜGEN',
              style: AppStyles.buttonText,
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
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: AppStyles.button,
              child: const Text(
                'Information HINZUFÜGEN',
                style: AppStyles.buttonText,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.05),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: AppStyles.removeButton,
              child: const Text(
                'Information ENTFERNEN',
                style: AppStyles.buttonText,
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
