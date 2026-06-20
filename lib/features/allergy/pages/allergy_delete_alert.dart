import 'package:flutter/material.dart';
import 'package:notfallbereit/theme/app_styles.dart';

class DeleteAllergyAlert extends StatelessWidget {
  const DeleteAllergyAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFf9cb9c),
      shape: AppStyles.alertShape,
      title: const Text('Allergie löschen'),
      content: const Text(
        'Möchtest du diese Allergie wirklich löschen?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        TextButton(
          onPressed: () {
            // Löschen
            Navigator.pop(context);
          },
          child: const Text('Löschen'),
        ),
      ],
    );
  }
}