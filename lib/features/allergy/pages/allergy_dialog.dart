import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:notfallbereit/features/alert/pages/custom_alert.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/features/allergy/pages/change_allergy_information.dart';
import '../../../core/api/api_config.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AllergyDialog extends StatelessWidget {
  final Map<String, dynamic> allergy;

  const AllergyDialog({super.key, required this.allergy});

  final storage = const FlutterSecureStorage();

  // sends the delete request
  Future<void> deleteAllergy(BuildContext context) async {
    final allergyId = allergy['id'];
    final emergencyProfileId = allergy['profile_id'];

    try {
      final token = await storage.read(key: "jwt");

      final response = await http.delete(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/allergy/$emergencyProfileId/$allergyId',
        ),
        headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': allergyId,
          'emergencyProfileId': emergencyProfileId,
        }),
      );

      // ensure widget is still in the widget tree
      if (!context.mounted) return;

      final data = jsonDecode(response.body);

      // shows a success or error message
      showSnackBar(context, data["message"], error: response.statusCode >= 400);

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      showSnackBar(
        context,
        "Es ist ein unerwarteter Fehler aufgetreten. + $e",
        error: true,
      );
    }
  }

  void showSnackBar(BuildContext context, String message, {bool error = true}) {
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

              SizedBox(height: screenHeight * 0.05),

              screenWidth > 1100
                  ? AutoSizeText(
                      'Allergie: ${allergy['allergen'].toString().toUpperCase()}',
                      style: AppStyles.title,
                      textAlign: TextAlign.center,
                      minFontSize: 30,
                      maxLines: 2,
                      stepGranularity: 1,
                      wrapWords: true,
                    )
                  : AutoSizeText(
                      'Allergie: ${allergy['allergen'].toString().toUpperCase()}',
                      style: AppStyles.mobileTitle,
                      textAlign: TextAlign.center,
                      minFontSize: 28,
                      maxLines: 2,
                      stepGranularity: 1,
                      wrapWords: true,
                    ),

              SizedBox(height: screenHeight * 0.05),

              Text('Notizen:', style: AppStyles.labelNormalUnderline),

              SizedBox(height: screenHeight * 0.02),

              Text('${allergy['notes']}', style: AppStyles.label),

              SizedBox(height: screenHeight * 0.05),

              screenWidth > 1100
                  ? Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: buildDeleteButton(context),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: buildEditButton(context),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildEditButton(context),
                        const SizedBox(height: 12),
                        buildDeleteButton(context),
                      ],
                    ),

              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDeleteButton(BuildContext context) {
    return ElevatedButton(
      style: AppStyles.removeButton,
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => CustomAlert(
            title: 'WARNUNG',
            message: 'Willst du diese Allergie wirklich löschen?',
            onConfirm: () => deleteAllergy(context),
          ),
        );
      },
      child: const Text('Löschen', style: AppStyles.buttonText),
    );
  }

  Widget buildEditButton(BuildContext context) {
    return ElevatedButton(
      style: AppStyles.whiteButton,
      onPressed: () async {
        final result = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => ChangeAllergyWindow(
            emergencyProfileId: allergy['profile_id'],
            allergyId: allergy['id'],
            allergen: allergy['allergen'].toString(),
            notes: allergy['notes']?.toString() ?? '',
          ),
        );

        // checks if a context page is mounted
        if (!context.mounted) return;

        if (result == true) {
          Navigator.pop(context, true);
        }
      },
      child: const Text(
        'Informationen bearbeiten',
        style: AppStyles.buttonTextBlack,
        textAlign: TextAlign.center,
      ),
    );
  }
}
