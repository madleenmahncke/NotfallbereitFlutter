import 'package:flutter/material.dart';

import '../features/auth/pages/start_page.dart';

void main() {
  runApp(
    const NotfallbereitApp(),
  );
}

class NotfallbereitApp extends StatelessWidget {
  const NotfallbereitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: 'Agenor',
      ),

      home: const StartPage(),
    );
  }
}