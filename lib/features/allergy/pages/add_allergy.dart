import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:notfallbereit/theme/app_styles.dart';

class AddAllergyWindow extends StatelessWidget {
  final int emergencyProfileId;

  const AddAllergyWindow({super.key, required this.emergencyProfileId});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    const double buttonWidth = 320;
    const double buttonHeight = 60;

    // TODO: if Abfrage im Button, ob es hinzufügen oder entfernen ist. Danach dann jeweils das passende weitere Fenster aufrufen

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
                'INFORMATION $title',
                style: AppStyles.title,
                minFontSize: 34,
              ),

              SizedBox(height: screenHeight * 0.05),

              SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  style: AppStyles.whiteButton,
                  onPressed: () {},
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
                  onPressed: () {},
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
                  onPressed: () {},
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
