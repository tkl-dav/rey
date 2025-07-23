import 'package:flutter/material.dart';
import 'register_choice_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key); // ✅ constructeur const

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.ac_unit, size: 100, color: Color(0xFF005A9C)),
              const SizedBox(height: 24),
              const Text(
                'Bienvenue chez Rey & Lenferna',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Application de gestion des interventions',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterChoicePage(), // ✅ const ici car la page est const
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005A9C),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                child: const Text(
                  'Commencer',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
