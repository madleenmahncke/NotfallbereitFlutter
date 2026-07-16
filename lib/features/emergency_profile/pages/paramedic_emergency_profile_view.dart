import 'package:flutter/material.dart';
import 'package:notfallbereit/features/emergency_contact/pages/paramedic_emergency_contact_dialog.dart';
import 'package:notfallbereit/features/medication/pages/paramedic_medication_dialog.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../allergy/pages/paramedic_allergy_dialog.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ParamedicEmergencyProfileView extends StatefulWidget {
  final Map<String, dynamic> emergencyProfile;
  final List<dynamic> allergies;
  final List<dynamic> medications;
  final List<dynamic> emergencyContacts;

  const ParamedicEmergencyProfileView({
    super.key,
    required this.emergencyProfile,
    required this.allergies,
    required this.medications,
    required this.emergencyContacts,
  });

  @override
  State<ParamedicEmergencyProfileView> createState() =>
      _ParamedicEmergencyProfileViewState();
}

class _ParamedicEmergencyProfileViewState
    extends State<ParamedicEmergencyProfileView> {
  List<dynamic> allergies = [];
  List<dynamic> medications = [];
  List<dynamic> emergencyContacts = [];

  Map<String, dynamic>? emergencyProfile;

  final storage = const FlutterSecureStorage();
  
  // initialize emergency profile data
  @override
  void initState() {
    super.initState();

    emergencyProfile = widget.emergencyProfile;

    allergies = widget.allergies;
    medications = widget.medications;
    emergencyContacts = widget.emergencyContacts;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (emergencyProfile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFA8C3A0),

      appBar: AppBar(
        backgroundColor: const Color(0xFFA8C3A0),
        elevation: 0,
        toolbarHeight: 80,

        automaticallyImplyLeading: false,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 180,
              height: 56,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF666666),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
                label: const Text('Zurück', style: AppStyles.appBarText),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),

            child: SizedBox(
              width: screenWidth * 0.9,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.06),

                  AutoSizeText(
                    'NOTFALLMAPPE',
                    style: AppStyles.title,
                    maxLines: 1,
                    minFontSize: 34,
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  AutoSizeText(
                    '${emergencyProfile!['first_name']} ${emergencyProfile!['last_name']}, ${emergencyProfile!['street']}, ${emergencyProfile!['zip_code']}',
                    maxLines: 6,
                    minFontSize: 24,
                    style: AppStyles.label,
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (screenWidth > 1300) {
                        return _buildDesktopLayout(context);
                      }

                      return _buildMobileLayout(context);
                    },
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

  Widget _buildDesktopLayout(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenHeight * 0.6,
      child: Row(
        children: [
          Expanded(child: _section('Allergien:', allergies, context)),

          SizedBox(width: screenWidth * 0.005),

          Expanded(child: _section('Medikamente:', medications, context)),

          SizedBox(width: screenWidth * 0.005),

          Expanded(
            child: _section('Notfallkontakte:', emergencyContacts, context),
          ),

          SizedBox(width: screenWidth * 0.005),

          Expanded(child: _section('Dokumente:', allergies, context)),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _section('Allergien:', allergies, context),

        const SizedBox(height: 20),

        _section('Medikamente:', medications, context),
        const SizedBox(height: 20),

        _section('Notfallkontakte:', emergencyContacts, context),
        const SizedBox(height: 20),

        _section('Dokumente:', allergies, context),
      ],
    );
  }

  Widget _section(String title, List<dynamic> entries, BuildContext context) {
    return Container(
      height: 250,

      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 15, 7, 42),
          width: 3,
        ),
      ),

      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),

            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(208, 15, 7, 42),
                  width: 1.5,
                ),
              ),
            ),

            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.tableTitleUnderlined,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final item = entries[index];

                  if (title == 'Allergien:') {
                    return TextButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => ParamedicAllergyDialog(allergy: item),
                        );
                      },
                      child: Text(
                        '› ${item['allergen']}',
                        style: AppStyles.text,
                      ),
                    );
                  }

                  if (title == 'Medikamente:') {
                    return TextButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => ParamedicMedicationDialog(medication: item),
                        );
                      },
                      child: Text('› ${item['name']}', style: AppStyles.text),
                    );
                  }

                  if (title == 'Notfallkontakte:') {
                    return TextButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              ParamedicEmergencyContactDialog(emergencyContact: item),
                        );
                      },
                      child: Text(
                        '› ${item['first_name']} ${item['last_name']}',
                        style: AppStyles.text,
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
