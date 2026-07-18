import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../core/api/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../emergency_profile/pages/paramedic_emergency_profile_view.dart';

class ParamedicScanQrCode extends StatefulWidget {
  const ParamedicScanQrCode({super.key});

  @override
  State<ParamedicScanQrCode> createState() => _ParamedicScanQrCodeState();
}

class _ParamedicScanQrCodeState extends State<ParamedicScanQrCode> {
  final _qrCodeUuidController = TextEditingController();

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // sends the qr code request
  Future<void> requestEmergencyProfile() async {
    try {
      final token = await storage.read(key: "jwt");

      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/emergencyProfile/qrCode/${_qrCodeUuidController.text}',
        ),
        headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      // shows a success or error message
      showSnackBar(data["message"], error: response.statusCode >= 400);

      if (response.statusCode == 201) {
        // ensure widget is still in the widget tree
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ParamedicEmergencyProfileView(
              emergencyProfile: data['emergencyProfile'],
              allergies: data['allergies'],
              medications: data['medications'],
              emergencyContacts: data['emergencyContacts'],
            ),
          ),
        );
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
                    'QR-CODE SCANNEN',
                    style: AppStyles.title,
                    maxLines: 1,
                    minFontSize: 34,
                  ),

                  SizedBox(height: screenHeight * 0.1),

                  // Label E-Mail
                  AutoSizeText(
                    'UUID eingeben zum Simulieren:',
                    style: AppStyles.label,
                    maxLines: 1,
                    minFontSize: 24,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // TextField E-Mail
                  TextField(
                    controller: _qrCodeUuidController,
                    maxLength: 255,
                    style: AppStyles.inputStyle,
                    decoration: AppStyles.textField(
                      'Hier UUID für Simulation eingeben...',
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () => requestEmergencyProfile(),
                    style: AppStyles.button,
                    child: Text(
                      'Scannen simulieren',
                      style: AppStyles.buttonText,
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
