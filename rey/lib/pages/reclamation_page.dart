import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SuiviReclamationsPage extends StatelessWidget {
  final List<Map<String, String>> reclamations = [
    {
      'id': 'REQ102345',
      'date': '10/07/2025',
      'etat': 'En attente',
      'type': 'Réparation',
      'details': 'Panne compresseur unité intérieure',
    },
    {
      'id': 'REQ102346',
      'date': '12/07/2025',
      'etat': 'En cours',
      'type': 'Maintenance',
      'details': 'Entretien complet prévu le 18/07',
    },
    {
      'id': 'REQ102347',
      'date': '14/07/2025',
      'etat': 'Résolu',
      'type': 'Devis',
      'details': 'Devis accepté pour unité 12000 BTU',
    },
  ];

  Color _statusColor(String etat) {
    switch (etat) {
      case 'En attente':
        return Colors.orange;
      case 'En cours':
        return Colors.blue;
      case 'Résolu':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Suivi des réclamations"),
        backgroundColor: const Color(0xFF005A9C),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reclamations.length,
        itemBuilder: (context, index) {
          final item = reclamations[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(Icons.report_problem, color: _statusColor(item['etat']!)),
              title: Text("Réclamation #${item['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date : ${item['date']}"),
                  Text("Type : ${item['type']}"),
                  Text("Statut : ${item['etat']}", style: TextStyle(color: _statusColor(item['etat']!))),
                  const SizedBox(height: 4),
                  Text("Détails : ${item['details']}", style: const TextStyle(fontStyle: FontStyle.italic)),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
