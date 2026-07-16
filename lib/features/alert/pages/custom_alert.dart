import 'package:flutter/material.dart';
import 'package:notfallbereit/theme/app_styles.dart';

// displays a confirmation dialog
class CustomAlert extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;

  const CustomAlert({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      backgroundColor: const Color(0xFFf9cb9c),
      shape: AppStyles.alertShape,

      actionsPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,

      title: Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.03),
        child: Center(child: Text(title, style: AppStyles.title)),
      ),

      content: Text(
        message,
        textAlign: TextAlign.center,
        style: AppStyles.text,
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: screenHeight * 0.05),

            const Divider(height: 1, thickness: 1, color: Color(0xFFFF9900)),

            SizedBox(
              height: 48,
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Nein', style: AppStyles.label),
                    ),
                  ),

                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Color(0xFFFF9900),
                  ),

                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        onConfirm();
                        Navigator.pop(context);
                      },
                      child: const Text('Ja', style: AppStyles.label),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
