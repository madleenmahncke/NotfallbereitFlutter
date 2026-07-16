import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import '../../../core/api/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangeAllergyWindow extends StatefulWidget {
  final int emergencyProfileId;
  final int allergyId;
  final String allergen;
  final String notes;

  const ChangeAllergyWindow({
    super.key,
    required this.allergyId,
    required this.emergencyProfileId,
    required this.allergen,
    required this.notes,
  });

  @override
  State<ChangeAllergyWindow> createState() => _ChangeAllergyWindowState();
}

class _ChangeAllergyWindowState extends State<ChangeAllergyWindow> {
  var _allergyNameController = TextEditingController();
  var _allergyNotesController = TextEditingController();

  final storage = const FlutterSecureStorage();

  // initialize text fields
  @override
  void initState() {
    super.initState();
    _allergyNameController = TextEditingController(text: widget.allergen);
    _allergyNotesController = TextEditingController(text: widget.notes);
  }

  String? _errorMessage;

  // sends the update request
  Future<void> updateAllergy() async {
    try {
      final token = await storage.read(key: "jwt");

      final response = await http.put(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/allergy/${widget.emergencyProfileId}/${widget.allergyId}',
        ),
        headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'emergencyProfileId': widget.emergencyProfileId,
          'id': widget.allergyId,
          'name': _allergyNameController.text,
          'notes': _allergyNotesController.text,
        }),
      );

      final data = jsonDecode(response.body);

      // shows a success or error message
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

      // ensure widget is still in the widget tree
      if (!mounted) return;

      if (response.statusCode == 201) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      showSnackBar(
        "Es ist ein unerwarteter Fehler aufgetreten. + $e",
        error: true,
      );
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
                'Allergie bearbeiten',
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
                controller: _allergyNameController,
                style: AppStyles.inputStyle,
                maxLength: 100,
                decoration: AppStyles.textField(
                  'Hier Namen der Allergie eingeben...',
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
                controller: _allergyNotesController,
                minLines: 5,
                maxLines: 10,
                maxLength: 500,
                style: AppStyles.inputStyle,
                decoration: AppStyles.textField(
                  'Hier Notizen zur Allergie eingeben...',
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
                onPressed: () => updateAllergy(),
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
