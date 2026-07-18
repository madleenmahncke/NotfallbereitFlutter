import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/features/user_profile/pages/user_profile.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../core/api/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangeEmergencyProfileInformationPage extends StatefulWidget {
  final Map<String, dynamic>? emergencyProfile;

  const ChangeEmergencyProfileInformationPage({
    super.key,
    required this.emergencyProfile,
  });

  @override
  State<ChangeEmergencyProfileInformationPage> createState() =>
      _ChangeEmergencyProfileInformationPageState();
}

class _ChangeEmergencyProfileInformationPageState
    extends State<ChangeEmergencyProfileInformationPage> {
  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _adressController = TextEditingController();
  var _locationController = TextEditingController();

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // initialize text fields
  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController(
      text: widget.emergencyProfile!['first_name'],
    );
    _lastNameController = TextEditingController(
      text: widget.emergencyProfile!['last_name'],
    );
    _adressController = TextEditingController(
      text: widget.emergencyProfile!['street_and_number'],
    );
    _locationController = TextEditingController(
      text: widget.emergencyProfile!['location'],
    );
  }

  // sends the changed emergency profile information request
  Future<void> changeEmergencyProfileInformation() async {
    try {
      final token = await storage.read(key: "jwt");

      final response = await http.put(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/emergencyProfile/updateEmergencyProfile/${widget.emergencyProfile!['id']}',
        ),
        headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'streetNumber': _adressController.text,
          'location': _locationController.text,
        }),
      );

      final data = jsonDecode(response.body);

      // shows a success or error message
      showSnackBar(data["message"], error: response.statusCode >= 400);

      if (response.statusCode == 200) {
        // ensure widget is still in the widget tree
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                UserProfilePage(emergencyProfileId: widget.emergencyProfile!['id']),
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // builds a password requirement row
  Widget passwordRequirement(String text, bool fulfilled) {
    return Row(
      children: [
        Icon(
          fulfilled ? Icons.check_circle : Icons.cancel,
          color: fulfilled
              ? const Color(0xFF274E13)
              : const Color.fromARGB(255, 204, 0, 0),
          size: 18,
        ),
        const SizedBox(width: 8),
        AutoSizeText(text, minFontSize: 18),
      ],
    );
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

    return Scaffold(
      backgroundColor: const Color(0xFFA8C3A0),

      appBar: AppBar(
        backgroundColor: const Color(0xFFA8C3A0),
        elevation: 0,
        leadingWidth: 180,

        leading: Padding(
          padding: const EdgeInsets.only(left: 12, top: 12),
          child: TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF666666),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            label: const Text('Zurück', style: AppStyles.appBarText),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),

            child: SizedBox(
              width: screenWidth * 0.8,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.1),

                  AutoSizeText(
                    'NOTFALLMAPPENDATEN ÄNDERN',
                    style: AppStyles.title,
                    maxLines: 1,
                    minFontSize: 34,
                  ),

                  SizedBox(height: screenHeight * 0.1),

                  AutoSizeText(
                    'Vorname:',
                    style: AppStyles.label,
                    maxLines: 1,
                    minFontSize: 24,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  TextField(
                    controller: _firstNameController,
                    style: AppStyles.inputStyle,
                    decoration: AppStyles.textField(
                      'Hier Vornamen eingeben...',
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.07),

                  AutoSizeText(
                    'Nachname:',
                    style: AppStyles.label,
                    maxLines: 1,
                    minFontSize: 24,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  TextField(
                    controller: _lastNameController,
                    style: AppStyles.inputStyle,
                    decoration: AppStyles.textField(
                      'Hier Nachnamen eingeben...',
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.07),

                  AutoSizeText(
                    'Adresse und Hausnummer:',
                    style: AppStyles.label,
                    maxLines: 1,
                    minFontSize: 24,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  TextField(
                    controller: _adressController,
                    style: AppStyles.inputStyle,
                    decoration: AppStyles.textField(
                      'Hier Adresse und Hausnummer eingeben...',
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.07),

                  AutoSizeText(
                    'Postleitzahl und Ort:',
                    style: AppStyles.label,
                    maxLines: 1,
                    minFontSize: 24,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  TextField(
                    controller: _locationController,
                    style: AppStyles.inputStyle,
                    decoration: AppStyles.textField(
                      'Hier Postleitzahl und Ort eingeben eingeben...',
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.08),

                  ElevatedButton(
                    onPressed: () => changeEmergencyProfileInformation(),
                    style: AppStyles.button,
                    child: Text(
                      'Bearbeiten',
                      style: AppStyles.buttonText,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
