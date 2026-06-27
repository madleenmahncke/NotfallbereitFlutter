import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import '../../../core/api/api_config.dart';

class ChangeEmergencyContactWindow extends StatefulWidget {
  final int emergencyProfileId;
  final int emergencyContactId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String relationship;

  const ChangeEmergencyContactWindow({
    super.key,
    required this.emergencyProfileId,
    required this.emergencyContactId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.relationship,
  });

  @override
  State<ChangeEmergencyContactWindow> createState() =>
      _ChangeEmergencyContactWindowState();
}

class _ChangeEmergencyContactWindowState
    extends State<ChangeEmergencyContactWindow> {
  var _emergencyContactFirstNameController = TextEditingController();
  var _emergencyContactLastNameController = TextEditingController();
  var _emergencyContactPhoneNumberController = TextEditingController();
  var _emergencyContactRelationshipController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _emergencyContactFirstNameController = TextEditingController(
      text: widget.firstName,
    );
    _emergencyContactLastNameController = TextEditingController(
      text: widget.lastName,
    );
    _emergencyContactPhoneNumberController = TextEditingController(
      text: widget.phoneNumber,
    );
    _emergencyContactRelationshipController = TextEditingController(
      text: widget.relationship,
    );
  }

  bool _loading = false;
  String? _message;

  Future<void> updateEmergencyContact() async {
    setState(() {
      _loading = true;
      _message = null;
    });

    try {
      final response = await http.put(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/emergencyContact/${widget.emergencyProfileId}/${widget.emergencyContactId}',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'emergencyProfileId': widget.emergencyProfileId,
          'id': widget.emergencyContactId,
          'firstName': _emergencyContactFirstNameController.text,
          'lastName': _emergencyContactLastNameController.text,
          'phoneNumber': _emergencyContactPhoneNumberController.text,
          'relationship': _emergencyContactRelationshipController.text,
        }),
      );

      final data = jsonDecode(response.body);

      setState(() {
        _message = data['message'];
      });

      if (response.statusCode == 201) {
        Navigator.pop(context, true);
      }
    } catch (e, stackTrace) {
      print('FEHLER: $e');
      print(stackTrace);

      setState(() {
        _message = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: const Color(0xFFA8C3A0),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),

          child: Column(
            children: [
              // Implementation help with faking the AppBar by !ChatGPT!
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 1, top: 12),
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: AppStyles.fakeAppBar,
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: const Text('Zurück', style: AppStyles.appBarText),
                  ),
                ),
              ),

              AutoSizeText(
                'Notfallkontakt bearbeiten',
                style: AppStyles.title,
                minFontSize: 34,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: screenHeight * 0.05),

              AutoSizeText(
                'Vornamen:',
                style: AppStyles.label,
                maxLines: 1,
                minFontSize: 24,
              ),

              SizedBox(height: screenHeight * 0.02),

              TextField(
                controller: _emergencyContactFirstNameController,
                style: AppStyles.inputStyle,
                maxLength: 100,
                decoration: AppStyles.textField(
                  'Hier den Vornamen des Kontakts eingeben...',
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              AutoSizeText(
                'Nachnamen:',
                style: AppStyles.label,
                maxLines: 1,
                minFontSize: 24,
              ),

              SizedBox(height: screenHeight * 0.02),

              TextField(
                controller: _emergencyContactLastNameController,
                style: AppStyles.inputStyle,
                maxLength: 100,
                decoration: AppStyles.textField(
                  'Hier den Nachnamen des Kontakts eingeben...',
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              AutoSizeText(
                'Telefonnummer:',
                style: AppStyles.label,
                maxLines: 1,
                minFontSize: 24,
              ),

              SizedBox(height: screenHeight * 0.02),

              TextField(
                controller: _emergencyContactPhoneNumberController,
                minLines: 5,
                maxLines: 10,
                maxLength: 30,
                style: AppStyles.inputStyle,
                decoration: AppStyles.textField(
                  'Hier die Telefonnummer des Kontakts eingeben...',
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              AutoSizeText(
                'Beziehung:',
                style: AppStyles.label,
                maxLines: 1,
                minFontSize: 24,
              ),

              SizedBox(height: screenHeight * 0.02),

              TextField(
                controller: _emergencyContactRelationshipController,
                minLines: 5,
                maxLines: 10,
                maxLength: 500,
                style: AppStyles.inputStyle,
                decoration: AppStyles.textField(
                  'Hier die Beziehung zum Kontakt eingeben...',
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              ElevatedButton(
                style: AppStyles.button,
                onPressed: () => updateEmergencyContact(),
                child: const Text(
                  'Speichern',
                  style: AppStyles.buttonText,
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: screenHeight * 0.07),
            ],
          ),
        ),
      ),
    );
  }
}
