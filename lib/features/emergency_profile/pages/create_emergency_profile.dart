import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/features/emergency_profile/pages/emergency_profile.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CreateEmergencyProfilePage extends StatefulWidget {
  final int userId;

  const CreateEmergencyProfilePage({super.key, required this.userId});

  @override
  State<CreateEmergencyProfilePage> createState() =>
      _CreateEmergencyProfilePageState();
}

class _CreateEmergencyProfilePageState
    extends State<CreateEmergencyProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _adressController = TextEditingController();
  final _zipCodeController = TextEditingController();

  bool _loading = false;
  String? _message;

  Future<void> createEmergencyProfile() async {
    setState(() {
      _loading = true;
      _message = null;
    });

    try {
      final response = await http.post(
        Uri.parse(
          'http://localhost:3000/api/emergencyProfile/${widget.userId}',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'street': _adressController.text,
          'zipCode': _zipCodeController.text,
        }),
      );

      final data = jsonDecode(response.body);

      setState(() {
        _message = data['message'];
      });

      debugPrint('Status: ${response.statusCode}');
      debugPrint(response.body);

      if (response.statusCode == 201) {
        final userId = data['userId'];
        final int? emergencyProfileId = data['emergencyProfileId'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EmergencyProfilePage(
              userId: userId,
              emergencyProfileId: emergencyProfileId!,
            ),
          ),
        );

        debugPrint('Erstellen des Notfallprofils erfolgreich. UserId: $userId');

        // TODO:
        // JWT speichern
        // Zur HomePage navigieren
      }
    } catch (e) {
      setState(() {
        _message = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _openEmergencyProfile(BuildContext context) {
    //Navigator.push(
    //context,
    //MaterialPageRoute(builder: (_) => const EmergencyProfilePage()),
    //);
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
                    'PERSONENDATEN',
                    style: AppStyles.title,
                    maxLines: 1,
                    minFontSize: 34,
                  ),

                  SizedBox(height: screenHeight * 0.1),

                  // Label first name
                  AutoSizeText(
                    'Vorname:',
                    style: AppStyles.label,
                    maxLines: 1,
                    minFontSize: 24,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // TextField first name
                  TextField(
                    controller: _firstNameController,
                    style: AppStyles.inputStyle,
                    decoration: AppStyles.textField(
                      'Hier Vornamen eingeben...',
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.07),

                  // Label last name
                  AutoSizeText(
                    'Nachname:',
                    style: AppStyles.label,
                    maxLines: 1,
                    minFontSize: 24,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // TextField last name
                  TextField(
                    controller: _lastNameController,
                    style: AppStyles.inputStyle,
                    decoration: AppStyles.textField(
                      'Hier Nachnamen eingeben...',
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.07),

                  // Label adress
                  AutoSizeText(
                    'Adresse:',
                    style: AppStyles.label,
                    maxLines: 1,
                    minFontSize: 24,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // TextField adress
                  TextField(
                    controller: _adressController,
                    style: AppStyles.inputStyle,
                    decoration: AppStyles.textField('Hier Adresse eingeben...'),
                  ),

                  SizedBox(height: screenHeight * 0.07),

                  // Label zip code and city
                  AutoSizeText(
                    'Postleitzahl und Ort:',
                    style: AppStyles.label,
                    maxLines: 1,
                    minFontSize: 24,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // TextField zip code and city
                  TextField(
                    controller: _zipCodeController,
                    style: AppStyles.inputStyle,
                    decoration: AppStyles.textField(
                      'Hier Postleitzahl und Ort eingeben eingeben...',
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.08),

                  ElevatedButton(
                    onPressed: () => createEmergencyProfile(),
                    style: AppStyles.button,
                    child: Text(
                      'Notfallmappe anlegen',
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
