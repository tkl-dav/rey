import 'package:flutter/material.dart';
import 'home_entreprise.dart';

class RegisterEntreprisePage extends StatefulWidget {
  const RegisterEntreprisePage({Key? key}) : super(key: key); // ✅ constructeur const

  @override
  _RegisterEntreprisePageState createState() => _RegisterEntreprisePageState();
}

class _RegisterEntreprisePageState extends State<RegisterEntreprisePage> {
  final _formKey = GlobalKey<FormState>();
  String nomEntreprise = '';
  String email = '';
  String telephone = '';
  String motDePasse = '';

  bool _isPasswordCompliant(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
    return regex.hasMatch(password);
  }

  bool _isPhoneValid(String phone) {
    final regex = RegExp(r'^\d{8}$');
    return regex.hasMatch(phone);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compte entreprise créé !')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeEntreprise(nomEntreprise: nomEntreprise),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF005A9C),
        title: const Text('Inscription - Entreprise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nom de l\'entreprise',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                onSaved: (value) => nomEntreprise = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email professionnel (@gmail.com)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Champ requis';
                  if (!value.endsWith('@gmail.com')) return 'Email doit se terminer par @gmail.com';
                  return null;
                },
                onSaved: (value) => email = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Téléphone (8 chiffres)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Champ requis';
                  if (!_isPhoneValid(value)) return 'Numéro invalide (8 chiffres requis)';
                  return null;
                },
                onSaved: (value) => telephone = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Champ requis';
                  if (!_isPasswordCompliant(value)) {
                    return 'Mot de passe trop faible (8+ caractères, majuscule, minuscule, chiffre et caractère spécial)';
                  }
                  return null;
                },
                onSaved: (value) => motDePasse = value!,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.business),
                label: const Text('Créer mon compte entreprise'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005A9C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
