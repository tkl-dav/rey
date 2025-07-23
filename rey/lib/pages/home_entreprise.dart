import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome_page.dart';
import 'Reparation_page.dart';
import 'package:rey/pages/maintenance_page.dart';
import 'package:rey/pages/quotation_page.dart';
import 'package:rey/pages/reclamation_page.dart';

class HomeEntreprise extends StatelessWidget {
  final String nomEntreprise;

  const HomeEntreprise({Key? key, required this.nomEntreprise}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
      (route) => false,
    );
  }

  void _showCGU(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Conditions Générales d'Utilisation"),
        content: const SingleChildScrollView(
          child: Text(
            "En utilisant cette application, vous acceptez nos conditions générales d'utilisation. "
            "Vos données seront utilisées uniquement dans le cadre de la maintenance, des devis et des réparations "
            "pour le service de climatisation.",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          )
        ],
      ),
    );
  }

  Widget _menuButton(BuildContext context, IconData icon, String label, Widget destination) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => destination)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF005A9C)),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF005A9C),
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 32),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Bienvenue : $nomEntreprise',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: "Déconnexion",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tableau de bord',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005A9C),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
                children: [
                  _menuButton(context, Icons.build, 'Réparation', const ReparationPage()),
                  _menuButton(context, Icons.settings, 'Maintenance', const MaintenancePage()),
                  _menuButton(context, Icons.request_quote, 'Devis', const QuotationPage()),
                  _menuButton(context, Icons.history, 'Suivi', const ReclamationPage()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
