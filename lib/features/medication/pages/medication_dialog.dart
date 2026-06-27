import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:notfallbereit/features/alert/pages/custom_alert.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/features/medication/pages/change_medication_information.dart';
import '../../../core/api/api_config.dart';
import 'package:notfallbereit/theme/app_styles.dart';

class MedicationDialog extends StatelessWidget {
  final Map<String, dynamic> medication;

  const MedicationDialog({super.key, required this.medication});

  Future<void> deleteMedication(BuildContext context) async {
    final medicationId = medication['id'];
    final emergencyProfileId = medication['profile_id'];

    try {
      final response = await http.delete(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/medication/$emergencyProfileId/$medicationId',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': medicationId,
          'emergencyProfileId': emergencyProfileId
        }),
      );

      debugPrint(response.statusCode.toString());
      debugPrint(response.body);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // TODO
  Future<void> changeMedicationInformation() async {}

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

              SizedBox(height: screenHeight * 0.05),

              Text(
                'Medikament: ${medication['name'].toString().toUpperCase()}',
                style: AppStyles.title,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: screenHeight * 0.05),

              Text(
                'Notizen:',
                style: AppStyles.labelNormalUnderline,
              ),

                            SizedBox(height: screenHeight * 0.02),

              Text(
                '${medication['notes'].toString()}',
                style: AppStyles.label,
              ),

              SizedBox(height: screenHeight * 0.05),

              // Implementation of Löschen and Informationen bearbeiten by !ChatGPT!
              SizedBox(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        style: AppStyles.removeButton,
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => CustomAlert(
                              title: 'WARNUNG',
                              message:
                                  'Willst du dieses Medikament wirklich löschen?',
                              onConfirm: () => deleteMedication(context),
                            ),
                          );
                        },
                        child: const Text(
                          'Löschen',
                          style: AppStyles.buttonText,
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: AppStyles.whiteButton,
                        onPressed: () async {
                          final result = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => ChangeMedicationWindow(
                              emergencyProfileId: medication['profile_id'],
                              medicationId: medication['id'],
                              name: medication['name'].toString(),
                              dosage: medication['dosage'].toString(),
                              notes: medication['notes']?.toString() ?? '',
                            ),
                          );

                          if (result == true) {
                            Navigator.pop(context, true);
                          }
                        },
                        child: const Text(
                          'Informationen bearbeiten',
                          style: AppStyles.buttonTextBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
