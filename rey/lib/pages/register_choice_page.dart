import 'package:flutter/material.dart';
import 'register_entreprise_page.dart';
import 'register_particulier_page.dart';

class RegisterChoicePage extends StatelessWidget {
  const RegisterChoicePage({Key? key}) : super(key: key);

  void _showFullCGU(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Conditions Générales d’Utilisation"),
        content: const SingleChildScrollView(
          child: Text(
            '''
Bienvenue dans l'application Rey & Lenferna.

1. 📋 Données collectées : utilisées uniquement pour la gestion de vos interventions.
2. 🔒 Confidentialité : vos informations ne seront jamais partagées.
3. ✅ Consentement : l’acceptation des CGU est obligatoire avant toute inscription.
4. 🛠️ Bon usage : les fonctionnalités doivent être utilisées à des fins professionnelles.
5. ❌ Suppression : vous pouvez demander à tout moment la suppression de vos données.
6. 📧 Contact : support@reylenferna.com
            ''',
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }

  void _showCGURequiredAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Conditions obligatoires"),
        content: const Text("Vous devez accepter les conditions d’utilisation pour continuer."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String type, bool isAccepted) {
    if (!isAccepted) {
      _showCGURequiredAlert(context);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            type == 'entreprise' ? const RegisterEntreprisePage() : const RegisterParticulierPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAccepted = false;

    return StatefulBuilder(
      builder: (context, setState) => Scaffold(
        appBar: AppBar(title: const Text("Créer un compte")),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: () => _navigateTo(context, 'entreprise', isAccepted),
                icon: const Icon(Icons.business),
                label: const Text("Je suis une entreprise"),
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => _navigateTo(context, 'particulier', isAccepted),
                icon: const Icon(Icons.person),
                label: const Text("Je suis un particulier"),
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              ),
              const SizedBox(height: 30),
              CheckboxListTile(
                value: isAccepted,
                onChanged: (val) => setState(() => isAccepted = val ?? false),
                title: Row(
                  children: [
                    const Text("J’accepte les "),
                    GestureDetector(
                      onTap: () => _showFullCGU(context),
                      child: const Text(
                        "conditions d’utilisation",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => _showFullCGU(context),
                  icon: const Icon(Icons.article_outlined),
                  label: const Text("Voir les CGU complètes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
