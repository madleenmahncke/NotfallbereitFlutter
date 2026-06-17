import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _adressController = TextEditingController();
  final _zipCodeController = TextEditingController();

  bool _loading = false;
  String? _message;

  void _openEmergencyProfile(BuildContext context) {
    // TODO!!!
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
          Expanded(child: _section('Allergien:', context)),

          SizedBox(width: screenWidth * 0.005),

          Expanded(child: _section('Medikamente:', context)),

          SizedBox(width: screenWidth * 0.005),

          Expanded(child: _section('Notfallkontakte:', context)),

          SizedBox(width: screenWidth * 0.005),

          Expanded(child: _section('Dokumente:', context)),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        _section('Allergien:', context),
        const SizedBox(height: 20),

        _section('Medikamente:', context),
        const SizedBox(height: 20),

        _section('Notfallkontakte:', context),
        const SizedBox(height: 20),

        _section('Dokumente:', context),
      ],
    );
  }

  Widget _section(String title, BuildContext context) {
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

          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '› Entlassungspapiere_Krankenhausaufenthalt_2025.pdf',
                    style: AppStyles.text,
                  ),
                ],
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
