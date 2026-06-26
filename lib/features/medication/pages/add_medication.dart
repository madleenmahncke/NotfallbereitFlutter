import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import '../../../core/api/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddMedicationWindow extends StatefulWidget {
  final int emergencyProfileId;

  const AddMedicationWindow({super.key, required this.emergencyProfileId});

  @override
  State<AddMedicationWindow> createState() => _AddMedicationWindow();
}

class _AddMedicationWindow extends State<AddMedicationWindow> {
  final _medicationNameController = TextEditingController();
  final _medicationDosageController = TextEditingController();
  final _medicationNotesController = TextEditingController();

  bool _loading = false;
  String? _message;

  Future<void> createMedication() async {
    setState(() {
      _loading = true;
      _message = null;
    });

    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/medication/${widget.emergencyProfileId}',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _medicationNameController.text,
          'dosage': _medicationDosageController.text,
          'notes': _medicationNotesController.text,
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
                'Medikament HINZUFÜGEN',
                style: AppStyles.title,
                minFontSize: 34,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: screenHeight * 0.05),

              AutoSizeText(
                'Name:',
                style: AppStyles.label,
                maxLines: 1,
                minFontSize: 24,
              ),

              SizedBox(height: screenHeight * 0.02),

              TextField(
                controller: _medicationNameController,
                style: AppStyles.inputStyle,
                maxLength: 100,
                decoration: AppStyles.textField(
                  'Hier Namen des Medikaments eingeben...',
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              AutoSizeText(
                'Dosierung:',
                style: AppStyles.label,
                maxLines: 1,
                minFontSize: 24,
              ),

              SizedBox(height: screenHeight * 0.02),

              TextField(
                controller: _medicationDosageController,
                style: AppStyles.inputStyle,
                maxLength: 100,
                decoration: AppStyles.textField(
                  'Hier Dosierung des Medikaments eingeben...',
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              AutoSizeText(
                'Notizen:',
                style: AppStyles.label,
                maxLines: 1,
                minFontSize: 24,
              ),

              SizedBox(height: screenHeight * 0.02),

              TextField(
                controller: _medicationNotesController,
                minLines: 5,
                maxLines: 10,
                maxLength: 500,
                style: AppStyles.inputStyle,
                decoration: AppStyles.textField(
                  'Hier Notizen zum Medikament eingeben...',
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              ElevatedButton(
                style: AppStyles.button,
                onPressed: () => createMedication(),
                child: const Text(
                  'Hinzufügen',
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
