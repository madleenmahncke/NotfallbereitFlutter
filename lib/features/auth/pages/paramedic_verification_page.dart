import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../core/api/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../unbenannt/pages/paramedic_scan_qr_code.dart';

class ParamedicVerificationPage extends StatefulWidget {
  final int paramedicId;

  const ParamedicVerificationPage({super.key, required this.paramedicId});

  @override
  State<ParamedicVerificationPage> createState() =>
      _ParamedicVerificationPageState();
}

class _ParamedicVerificationPageState extends State<ParamedicVerificationPage> {
  final _verificationCodeController = TextEditingController();

  bool _loading = false;
  String? _message;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> verify() async {
    setState(() {
      _loading = true;
      _message = null;
    });

    try {
      final token = await storage.read(key: "jwt");

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/login/verifyParamedic'),
        headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'paramedicId': widget.paramedicId,
          'verificationCode': _verificationCodeController.text,
        }),
      );

      // TODO: richtige Fehlermeldung einbauen mit Alerts
      debugPrint('Status: ${response.statusCode}');
      debugPrint(response.body);

      final data = jsonDecode(response.body);

      setState(() {
        _message = data['message'];
      });

      if (response.statusCode == 200) {
        final int userId = data['userId'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ParamedicScanQrCode()),
        );sobel(src)

        debugPrint('Verifizierung erfolgreich. UserId: $userId');
      }
    } catch (e) {
      setState(() {
        _message = e.toString();
      });

      debugPrint("Storage-Fehler: $e");
    } finally {
      setState(() {
        _loading = false;
      });
    }
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

                  // Title Login
                  AutoSizeText(
                    'VERIFIZIERUNG',
                    style: AppStyles.title,
                    maxLines: 1,
                    minFontSize: 34,
                  ),

                  SizedBox(height: screenHeight * 0.1),

                  // Label E-Mail
                  AutoSizeText(
                    'Verifizierungscode:',
                    style: AppStyles.label,
                    maxLines: 1,
                    minFontSize: 24,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // TextField E-Mail
                  TextField(
                    controller: _verificationCodeController,
                    maxLength: 255,
                    style: AppStyles.inputStyle,
                    decoration: AppStyles.textField(
                      'Hier Verifizierungscode eingeben...',
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.08),

                  ElevatedButton(
                    onPressed: () => verify(),
                    style: AppStyles.button,
                    child: Text('Verifizieren', style: AppStyles.buttonText),
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
