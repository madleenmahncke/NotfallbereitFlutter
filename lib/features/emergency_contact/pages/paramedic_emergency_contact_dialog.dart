import 'package:flutter/material.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ParamedicEmergencyContactDialog extends StatelessWidget {
  final Map<String, dynamic> emergencyContact;

  const ParamedicEmergencyContactDialog({
    super.key,
    required this.emergencyContact,
  });

  final storage = const FlutterSecureStorage();

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

              Text(
                'Notfallkontakt: ${emergencyContact['first_name'].toString().toUpperCase()} ${emergencyContact['last_name'].toString().toUpperCase()}',
                style: AppStyles.title,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: screenHeight * 0.05),

              Text('Telefonnummer:', style: AppStyles.labelNormalUnderline),

              SizedBox(height: screenHeight * 0.02),

              Text(
                '${emergencyContact['phone'].toString()}',
                style: AppStyles.label,
              ),

              SizedBox(height: screenHeight * 0.04),

              Text('Beziehung:', style: AppStyles.labelNormalUnderline),

              SizedBox(height: screenHeight * 0.02),

              Text(
                '${emergencyContact['relationship'].toString()}',
                style: AppStyles.label,
              ),

              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
