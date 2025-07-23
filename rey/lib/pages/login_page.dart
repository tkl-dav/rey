import 'package:flutter/material.dart';
import 'register_choice_page.dart';          // Page de création de compte (choix entreprise/particulier)
import 'home_particulier.dart';             // Accueil si particulier
import 'home_entreprise.dart';              // Accueil si entreprise

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Clé pour valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // Variables pour stocker les entrées utilisateur
  String email = '';
  String password = '';
  String userType = 'particulier'; // Valeur par défaut du type utilisateur

  // Fonction appelée lorsqu'on clique sur "Se connecter"
  void _login() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // 🔧 À remplacer plus tard par une vraie vérification dans la base
      bool compteExiste = false;

      if (compteExiste) {
        // Si le compte existe, on redirige vers la bonne page
        if (userType == 'entreprise') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeEntreprise(email: email),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeParticulier(email: email),
            ),
          );
        }
      } else {
        // Si le compte n’existe pas → afficher une bulle (dialog)
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Compte introuvable"),
            content: Text(
                "Aucun compte associé à cet email. Souhaitez-vous en créer un ?"),
            actions: [
              TextButton(
                child: Text("Annuler"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: Text("Créer un compte"),
                onPressed: () {
                  Navigator.pop(context); // Ferme le dialog
                  // Redirige vers la page de choix : entreprise ou particulier
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterChoicePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey, // Associe la clé de validation au formulaire
          child: ListView(
            children: [
              // Sélection du type d’utilisateur
              DropdownButtonFormField<String>(
                value: userType,
                items: [
                  DropdownMenuItem(
                      value: 'particulier', child: Text('Particulier')),
                  DropdownMenuItem(
                      value: 'entreprise', child: Text('Entreprise')),
                ],
                onChanged: (value) {
                  setState(() {
                    userType = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Type d’utilisateur'),
              ),

              SizedBox(height: 16),

              // Champ email
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) => email = value!,
                validator: (value) =>
                    value!.isEmpty ? "Entrez votre email" : null,
              ),

              // Champ mot de passe
              TextFormField(
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                onSaved: (value) => password = value!,
                validator: (value) =>
                    value!.isEmpty ? "Entrez votre mot de passe" : null,
              ),

              SizedBox(height: 24),

              // Bouton de connexion
              ElevatedButton(
                onPressed: _login,
                child: Text("Se connecter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
