import 'package:flutter/material.dart';
import 'package:notfallbereit/features/auth/pages/login_page.dart';
import 'package:notfallbereit/features/auth/pages/register_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  void _openLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
    );
  }

  void _openRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8C3A0),

      appBar: AppBar(
        backgroundColor: const Color(0xFFA8C3A0),
        elevation: 0,
      ),

      body: Stack(
        children: [

          const Align(
            alignment: Alignment(0, -0.65),
            child: Text(
              'NOTFALLBEREIT',
              style: TextStyle(
                fontFamily: 'Agenor',
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Color(0xFF20124D),
              ),
            ),
          ),

          // Login mittig
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 260,
              height: 60,
              child: ElevatedButton(
                onPressed: () => _openLogin(context),

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF274E13),
                  foregroundColor: Colors.white,
                ),

                child: const Text(
                  'Anmelden',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),

          // Registrierung darunter
          Align(
            alignment: const Alignment(0, 0.35),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Text(
                  'Noch kein Konto?',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF20124D),
                  ),
                ),

                TextButton(
                  onPressed: () => _openRegister(context),

                  child: const Text(
                    'Registrieren',
                    style: TextStyle(
                      fontSize: 24,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}