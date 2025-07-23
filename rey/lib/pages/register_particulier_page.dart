import 'package:flutter/material.dart';
import 'home_particulier.dart';

class RegisterParticulierPage extends StatefulWidget {
  const RegisterParticulierPage({Key? key}) : super(key: key);

  @override
  _RegisterParticulierPageState createState() => _RegisterParticulierPageState();
}

class _RegisterParticulierPageState extends State<RegisterParticulierPage> {
  final _formKey = GlobalKey<FormState>();
  String nom = '';
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
        const SnackBar(content: Text('Compte particulier créé !')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeParticulier(nom: nom),
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
        title: const Text('Inscription - Particulier'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nom complet',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                onSaved: (value) => nom = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email (@gmail.com)',
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
                    return 'Mot de passe faible : 8+ caractères, majuscule, minuscule, chiffre et caractère spécial requis';
                  }
                  return null;
                },
                onSaved: (value) => motDePasse = value!,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.person),
                label: const Text('Créer mon compte particulier'),
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
