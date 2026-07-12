import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import '../../../core/api/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangeMedicationWindow extends StatefulWidget {
  final int emergencyProfileId;
  final int medicationId;
  final String name;
  final String dosage;
  final String notes;

  const ChangeMedicationWindow({
    super.key,
    required this.emergencyProfileId,
    required this.medicationId,
    required this.name,
    required this.dosage,
    required this.notes,
  });

  @override
  State<ChangeMedicationWindow> createState() => _ChangeMedicationWindowState();
}

class _ChangeMedicationWindowState extends State<ChangeMedicationWindow> {
  var _medicationNameController = TextEditingController();
  var _medicationDosageController = TextEditingController();
  var _medicationNotesController = TextEditingController();

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    _medicationNameController = TextEditingController(text: widget.name);
    _medicationDosageController = TextEditingController(text: widget.dosage);
    _medicationNotesController = TextEditingController(text: widget.notes);
  }

  bool _loading = false;
  String? _message;
  String? _errorMessage;

  Future<void> updateMedication() async {
    setState(() {
      _loading = true;
      _message = null;
    });

    try {
      final token = await storage.read(key: "jwt");

      final response = await http.put(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/medication/${widget.emergencyProfileId}/${widget.medicationId}',
        ),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'emergencyProfileId': widget.emergencyProfileId,
          'id': widget.medicationId,
          'name': _medicationNameController.text,
          'dosage': _medicationDosageController.text,
          'notes': _medicationNotesController.text,
        }),
      );

      final data = jsonDecode(response.body);
      showSnackBar(data["message"], error: response.statusCode >= 400);

      if (response.statusCode >= 400) {
        setState(() {
          _errorMessage = data["message"];
        });
      } else {
        setState(() {
          _errorMessage = null;
        });
      }

      if (response.statusCode == 201) {
        Navigator.pop(context, true);
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
                'Medikament bearbeiten',
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
                minLines: 5,
                maxLines: 10,
                maxLength: 100,
                style: AppStyles.inputStyle,
                decoration: AppStyles.textField(
                  'Hier Dosierung vom Medikament eingeben...',
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

              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: AppStyles.errorText,
                  textAlign: TextAlign.center,
                ),

              ElevatedButton(
                style: AppStyles.button,
                onPressed: () => updateMedication(),
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
