import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle label = TextStyle(
    fontSize: 24,
    color: Color(0xFF20124D),
  );

  static const TextStyle title = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.bold,
    color: Color(0xFF20124D),
  );

  static final ButtonStyle button = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF274E13),
    foregroundColor: Colors.white,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 36,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle inputStyle = TextStyle(
    fontSize: 24,
    color: Color(0xFF20124D),
  );

  static InputDecoration textField(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
      ),
    );
  }
}
