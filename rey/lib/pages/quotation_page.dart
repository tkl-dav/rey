import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class QuotationPage extends StatefulWidget {
  const QuotationPage({super.key});

  @override
  State<QuotationPage> createState() => _QuotationPageState();
}

class _QuotationPageState extends State<QuotationPage> {
  final TextEditingController besoinController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController villeController = TextEditingController();
  final TextEditingController rueController = TextEditingController();

  String? selectedType;
  String? selectedSerie;
  String? selectedCapacite;
  String? selectedModele;

  final String dateDemande = DateFormat('dd/MM/yyyy').format(DateTime.now());
  final String idDemande = 'QUO${Random().nextInt(999999).toString().padLeft(6, '0')}';

  final List<Map<String, String>> modelesDetail = [
    {"modele": "MSA12HRN1", "type": "Split", "serie": "AURORA", "capacite": "9000 BTU"},
    {"modele": "MSP18HRN3", "type": "Cassette", "serie": "PRO", "capacite": "12000 BTU"},
    {"modele": "MSA24HRQ1", "type": "VRV", "serie": "ELITE", "capacite": "18000 BTU"},
  ];

  final List<String> types = ["Split", "Cassette", "VRV"];
  final List<String> series = ["AURORA", "PRO", "ELITE"];
  final List<String> capacites = ["9000 BTU", "12000 BTU", "18000 BTU"];

  List<String> _filteredModeles(String filter) {
    return modelesDetail
        .where((item) => (selectedType == null || item['type'] == selectedType) &&
            (selectedSerie == null || item['serie'] == selectedSerie) &&
            (selectedCapacite == null || item['capacite'] == selectedCapacite) &&
            (filter.isEmpty || item['modele']!.toLowerCase().contains(filter.toLowerCase())))
        .map((e) => e['modele']!)
        .toList();
  }

  Future<void> _selectFromList(String title, List<String> options, Function(String) onSelected) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          height: 200,
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(options[index]),
              onTap: () => Navigator.pop(context, options[index]),
            ),
          ),
        ),
      ),
    );

    if (result != null) onSelected(result);
  }

  Future<void> _selectModeleDialog() async {
    TextEditingController searchController = TextEditingController();
    String filter = "";

    await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Sélectionner un modèle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(hintText: "Rechercher un modèle..."),
                onChanged: (val) => setState(() => filter = val),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.maxFinite,
                height: 200,
                child: ListView(
                  children: _filteredModeles(filter).map((modele) => ListTile(
                    title: Text(modele),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        selectedModele = modele;
                        final match = modelesDetail.firstWhere((e) => e['modele'] == modele);
                        selectedType = match['type'];
                        selectedSerie = match['serie'];
                        selectedCapacite = match['capacite'];
                      });
                    },
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if ((selectedModele == null && (selectedType == null || selectedSerie == null || selectedCapacite == null)) ||
        besoinController.text.isEmpty ||
        adresseController.text.isEmpty ||
        villeController.text.isEmpty ||
        rueController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Récapitulatif"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date: $dateDemande"),
            Text("ID: $idDemande"),
            Text("Modèle: ${selectedModele ?? "Non précisé"}"),
            Text("Type: ${selectedType ?? "-"}"),
            Text("Série: ${selectedSerie ?? "-"}"),
            Text("Capacité: ${selectedCapacite ?? "-"}"),
            Text("Besoin: ${besoinController.text}"),
            Text("Adresse: ${adresseController.text}, ${rueController.text}, ${villeController.text}"),
            const SizedBox(height: 8),
            const Text("Prix estimé: 2000 MUR", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Payer")),
        ],
      ),
    );
  }

  Widget _buildDropdownSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: _selectModeleDialog,
              child: Text(selectedModele ?? "Choisir un modèle (popup + recherche)"),
            ),
            if (selectedModele == null)
              ElevatedButton(
                onPressed: () => _selectFromList("Choisir un type", types, (val) => setState(() => selectedType = val)),
                child: Text(selectedType ?? "Type"),
              ),
            if (selectedModele == null)
              ElevatedButton(
                onPressed: () => _selectFromList("Choisir une série", series, (val) => setState(() => selectedSerie = val)),
                child: Text(selectedSerie ?? "Série"),
              ),
            if (selectedModele == null)
              ElevatedButton(
                onPressed: () => _selectFromList("Choisir une capacité", capacites, (val) => setState(() => selectedCapacite = val)),
                child: Text(selectedCapacite ?? "Capacité"),
              ),
          ],
        ),
        if (selectedModele == null)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Wrap(
              spacing: 8,
              children: _filteredModeles("").map((model) => OutlinedButton(
                onPressed: () => setState(() => selectedModele = model),
                child: Text(model),
              )).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildAdresseFields() {
    return Column(
      children: [
        TextField(
          controller: adresseController,
          decoration: const InputDecoration(labelText: "Adresse", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: rueController,
          decoration: const InputDecoration(labelText: "Rue", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: villeController,
          decoration: const InputDecoration(labelText: "Ville", border: OutlineInputBorder()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demande de devis"),
        backgroundColor: const Color(0xFF005A9C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDropdownSection(),
              const SizedBox(height: 20),
              TextField(
                controller: besoinController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Votre besoin en climatisation",
                  hintText: "Décrivez votre besoin pour un meilleur devis...",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              _buildAdresseFields(),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.send),
                label: const Text("Envoyer la demande"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF005A9C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
