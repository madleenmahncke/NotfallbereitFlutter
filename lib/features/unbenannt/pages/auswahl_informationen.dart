import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:notfallbereit/features/allergy/pages/add_allergy.dart';
import 'package:notfallbereit/features/emergency_contact/pages/add_emergency_contact.dart';
import 'package:notfallbereit/features/medication/pages/add_medication.dart';
import 'package:notfallbereit/theme/app_styles.dart';

class SelectInformationWindow extends StatelessWidget {
  final String title;
  final int emergencyProfileId;

  const SelectInformationWindow({
    super.key,
    required this.title,
    required this.emergencyProfileId,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    const double buttonWidth = 320;
    const double buttonHeight = 80;

    // TODO: if Abfrage im Button, ob es hinzufügen oder entfernen ist. Danach dann jeweils das passende weitere Fenster aufrufen

    bool addInformation = false;

    if (title == 'HINZUFÜGEN') {
      addInformation = true;
    }

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
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    label: const Text('Zurück', style: AppStyles.appBarText),
                  ),
                ),
              ),

              AutoSizeText(
                'Information $title',
                style: AppStyles.title,
                maxLines: 2,
                minFontSize: 34,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: screenHeight * 0.05),

              SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  style: AppStyles.whiteButton,
                  onPressed: addInformation
                      ? () async {
                          final result = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AddAllergyWindow(
                              emergencyProfileId: emergencyProfileId,
                            ),
                          );

                          if (result == true) {
                            Navigator.pop(context, true);
                          }
                        }
                      : () {},
                  child: const Text(
                    'Allergie',
                    style: AppStyles.label,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  style: AppStyles.whiteButton,
                  onPressed: addInformation
                      ? () async {
                          final result = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AddMedicationWindow(
                              emergencyProfileId: emergencyProfileId,
                            ),
                          );

                          if (result == true) {
                            Navigator.pop(context, true);
                          }
                        }
                      : () {},
                  child: const Text(
                    'Medikament',
                    style: AppStyles.label,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  style: AppStyles.whiteButton,
                  onPressed: addInformation
                      ? () async {
                          final result = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AddEmergencyContactWindow(
                              emergencyProfileId: emergencyProfileId,
                            ),
                          );

                          if (result == true) {
                            Navigator.pop(context, true);
                          }
                        }
                      : () {},
                  child: const Text(
                    'Notfallkontakt',
                    style: AppStyles.label,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  style: AppStyles.whiteButton,
                  onPressed: () {},
                  child: const Text(
                    'Dokument',
                    style: AppStyles.label,
                    textAlign: TextAlign.center,
                  ),
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
