import 'package:flutter/material.dart';
import 'package:notfallbereit/footer/pages/privacy_policy.dart';
import 'package:notfallbereit/footer/pages/video_to_app.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LegalNoticePage extends StatelessWidget {
  const LegalNoticePage({super.key});

  void _openLegalNotice(BuildContext context) {
    // do nothing :)
  }

  void _openVideoToAppPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const VideoToAppPage()),
    );
  }

  void _openPrivacyPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
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
                    'IMPRESSUM',
                    style: AppStyles.title,
                    maxLines: 1,
                    minFontSize: 34,
                  ),

                  SizedBox(height: screenHeight * 0.1),

                  RichText(
                    text: TextSpan(
                      style: AppStyles.label,
                      children: [
                        const TextSpan(
                          text: '''Max Mustermann

Musterstraße 111
Gebäude 44
90210 Musterstadt

Kontakt
Telefon: +49 (0) 123 44 55 66
Telefax: +49 (0) 123 44 55 99
E-Mail: mustermann@musterfirma.de

Quelle: https://www.e-recht24.de''',
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: screenWidth < 1100
            ? _buildMobileLayout(context)
            : _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(
            style: AppStyles.footerButton,
            onPressed: () => _openLegalNotice(context),
            child: const Text("Impressum"),
          ),

          SizedBox(height: screenHeight * 0.02),

          ElevatedButton(
            style: AppStyles.footerVideoButton,
            onPressed: () => _openVideoToAppPage(context),
            child: const Text("Video zur App"),
          ),

          SizedBox(height: screenHeight * 0.02),

          OutlinedButton(
            style: AppStyles.footerButton,
            onPressed: () => _openPrivacyPage(context),
            child: const Text("Datenschutzerklärung"),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            style: AppStyles.footerButton,
            onPressed: () => _openLegalNotice(context),
            child: const Text("Impressum"),
          ),

          ElevatedButton(
            style: AppStyles.footerVideoButton,
            onPressed: () => _openVideoToAppPage(context),
            child: const Text("Video zur App"),
          ),

          OutlinedButton(
            style: AppStyles.footerButton,
            onPressed: () => _openPrivacyPage(context),
            child: const Text("Datenschutzerklärung"),
          ),
        ],
      ),
    );
  }
}
