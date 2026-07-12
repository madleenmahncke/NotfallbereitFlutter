import 'package:flutter/material.dart';
import 'package:notfallbereit/features/auth/pages/paramedic_index.dart';

import 'features/auth/pages/index.dart';

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

      home: const Index(),
      //home: const ParamedicIndex()
    );
  }
}