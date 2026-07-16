import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle label = TextStyle(
    fontSize: 24,
    color: Color(0xFF20124D),
    fontWeight: FontWeight.bold,
  );

  static const TextStyle labelNormalUnderline = TextStyle(
    fontSize: 24,
    color: Color(0xFF20124D),
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
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
    fontWeight: FontWeight.bold,
  );

  static const TextStyle title = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.bold,
    color: Color(0xFF20124D),
  );

  static const TextStyle mobileTitle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Color(0xFF20124D),
  );

  static const TextStyle errorText = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 204, 0, 0),
  );

  static final ButtonStyle button = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF274E13),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
  );

  static final ButtonStyle whiteButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
  );

  static final ButtonStyle qrCodeButton = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF70A7DD),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
  );

  static final ButtonStyle removeButton = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 204, 0, 0),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
  );

  static final ButtonStyle fakeAppBar = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF666666),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  static final ButtonStyle footerButton = OutlinedButton.styleFrom(
    backgroundColor: const Color(0xFFE8E8E8),
    foregroundColor: Color(0xFF20124D),
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
    side: const BorderSide(color: Colors.grey),
  );

  static final ButtonStyle footerVideoButton = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFF4B266),
    foregroundColor: Color(0xFF20124D),
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
    side: const BorderSide(color: Colors.grey),
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 30,
    color: Colors.white,
  );

  static const TextStyle buttonTextBlack = TextStyle(
    fontSize: 30,
    color: Colors.black,
  );

  static const TextStyle emergencyProfileInformationButtonText = TextStyle(
    fontSize: 26,
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
      hintMaxLines: 3,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
    );
  }

  static final alertShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(28),
    side: const BorderSide(color: Color(0xFFFF9900), width: 2),
  );
}
