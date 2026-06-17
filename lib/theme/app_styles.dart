import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle label = TextStyle(
    fontSize: 24,
    color: Color(0xFF20124D),
    fontWeight: FontWeight.bold
  );

  static const TextStyle labelUnderline = TextStyle(
    fontSize: 24,
    color: Color.fromARGB(255, 79, 28, 247),
    decoration: TextDecoration.underline,
  );

  static const TextStyle text = TextStyle(
    fontSize: 24,
    color: Color(0xFF20124D),
  );

  static const TextStyle tableTitleUnderlined = TextStyle(
    fontSize: 30,
    color: Color(0xFF20124D),
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.bold
  );

  static const TextStyle title = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.bold,
    color: Color(0xFF20124D),
  );

  static final ButtonStyle button = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF274E13),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
  );

  static final ButtonStyle removeButton = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 204, 0, 0),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 30,
    color: Colors.white,
  );

  static const TextStyle appBarText = TextStyle(
    fontSize: 24,
    color: Colors.white,
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
      border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
    );
  }
}
