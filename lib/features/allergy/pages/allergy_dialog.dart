import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:notfallbereit/features/alert/pages/custom_alert.dart';
import 'package:notfallbereit/features/allergy/pages/allergy_delete_alert.dart';
import 'package:notfallbereit/features/emergency_profile/pages/emergency_profile.dart';
import 'package:http/http.dart' as http;
import '../../../core/api/api_config.dart';
import 'package:notfallbereit/theme/app_styles.dart';

class AllergyDialog extends StatelessWidget {
  final Map<String, dynamic> allergy;

  const AllergyDialog({super.key, required this.allergy});

  Future<void> deleteAllergy(BuildContext context) async {
    final allergyId = allergy['id'];
    final emergencyProfileId = allergy['profile_id'];

    try {
      final response = await http.delete(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/allergy/$emergencyProfileId/$allergyId',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': allergyId,
          'emergencyProfileId': emergencyProfileId,
          'name': allergy['allergen'],
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

  Future<void> changeAllergyInformation() async {}

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
                'ALLERGIE: ${allergy['allergen'].toString().toUpperCase()}',
                style: AppStyles.title,
              ),

              SizedBox(height: screenHeight * 0.05),

              const Text(
                'Notizen: HIER FEHLT NOCH DIE INFO ÜBERGABE??? :(',
                //'Notizen: ${allergy['notes'].toString()}',
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
                                  'Willst du diese Allergie wirklich löschen?',
                              onConfirm: () => deleteAllergy(context),
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
                        onPressed: () => changeAllergyInformation(),
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
