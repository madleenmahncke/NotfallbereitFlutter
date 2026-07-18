import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import '../../../core/api/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  final storage = const FlutterSecureStorage();

  // sends the medication to the backend
  Future<void> createMedication() async {
    try {
      final token = await storage.read(key: "jwt");

      final response = await http.post(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/medication/${widget.emergencyProfileId}',
        ),
        headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': _medicationNameController.text,
          'dosage': _medicationDosageController.text,
          'notes': _medicationNotesController.text,
        }),
      );

      final data = jsonDecode(response.body);

      // shows a success or error message
      showSnackBar(data["message"], error: response.statusCode >= 400);

      // ensure widget is still in the widget tree
      if (!mounted) return;

      if (response.statusCode == 201) {
        Navigator.pop(context, true);
      }
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
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                    label: const Text('Zurück', style: AppStyles.appBarText),
                  ),
                ),
              ),

              AutoSizeText(
                'Medikament HINZUFÜGEN',
                style: AppStyles.title,
                minFontSize: 34,
                maxLines: 2,
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
