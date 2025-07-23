import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({Key? key}) : super(key: key);

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController villeController = TextEditingController();
  final TextEditingController rueController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedModele;
  String? selectedType;
  String? selectedSerie;
  String? selectedCapacite;
  List<String> selectedMaintenances = [];

  final String dateDemande = DateFormat('dd/MM/yyyy').format(DateTime.now());
  final String idDemande = 'MAI${Random().nextInt(999999).toString().padLeft(6, '0')}';

  final List<Map<String, String>> modelesDetail = [
    {"modele": "MSA12HRN1", "type": "Split", "serie": "AURORA", "capacite": "9000 BTU"},
    {"modele": "MSP18HRN3", "type": "Cassette", "serie": "PRO", "capacite": "12000 BTU"},
    {"modele": "MSA24HRQ1", "type": "VRV", "serie": "ELITE", "capacite": "18000 BTU"},
  ];

  final List<String> maintenances = [
    "Nettoyage filtres", "Entretien complet", "Recharge gaz", "Inspection système", "Vérification électrique"
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
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            height: 200,
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(options[index]),
                  onTap: () => Navigator.pop(context, options[index]),
                );
              },
            ),
          ),
        );
      },
    );

    if (result != null) onSelected(result);
  }

  Future<void> _selectModeleDialog() async {
    TextEditingController searchController = TextEditingController();
    String filter = "";

    await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text("Sélectionner un modèle"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(hintText: "Rechercher un modèle..."),
                  onChanged: (val) => setState(() => filter = val),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.maxFinite,
                  height: 200,
                  child: ListView(
                    children: _filteredModeles(filter).map((modele) {
                      return ListTile(
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
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitForm() {
    if ((selectedModele == null && (selectedType == null || selectedSerie == null || selectedCapacite == null)) ||
        selectedMaintenances.isEmpty ||
        adresseController.text.isEmpty ||
        villeController.text.isEmpty ||
        rueController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Récapitulatif"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date: $dateDemande"),
            Text("ID: $idDemande"),
            Text("Services: ${selectedMaintenances.join(", ")}"),
            Text("Modèle: ${selectedModele ?? "Non précisé"}"),
            Text("Type: ${selectedType ?? "-"}"),
            Text("Série: ${selectedSerie ?? "-"}"),
            Text("Capacité: ${selectedCapacite ?? "-"}"),
            Text("Adresse: ${adresseController.text}, ${rueController.text}, ${villeController.text}"),
            Text("Détails: ${descriptionController.text}"),
            SizedBox(height: 8),
            Text("Prix estimé: 1200 MUR", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Annuler")),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Payer")),
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
              onPressed: () async {
                final result = await showDialog<List<String>>(
                  context: context,
                  builder: (context) {
                    List<String> selected = [...selectedMaintenances];
                    return StatefulBuilder(
                      builder: (context, setState) => AlertDialog(
                        title: Text("Choisir les services de maintenance"),
                        content: SingleChildScrollView(
                          child: Column(
                            children: maintenances.map((m) {
                              return CheckboxListTile(
                                title: Text(m),
                                value: selected.contains(m),
                                onChanged: (val) {
                                  setState(() {
                                    if (val!) selected.add(m);
                                    else selected.remove(m);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Annuler"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, selected),
                            child: Text("Valider"),
                          ),
                        ],
                      ),
                    );
                  },
                );

                if (result != null) setState(() => selectedMaintenances = result);
              },
              child: Text(selectedMaintenances.isEmpty ? "Choisir un ou plusieurs services" : selectedMaintenances.join(", ")),
            ),
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
          decoration: InputDecoration(labelText: "Adresse", border: OutlineInputBorder()),
          keyboardType: TextInputType.streetAddress,
        ),
        SizedBox(height: 10),
        TextField(
          controller: rueController,
          decoration: InputDecoration(labelText: "Rue", border: OutlineInputBorder()),
          keyboardType: TextInputType.streetAddress,
        ),
        SizedBox(height: 10),
        TextField(
          controller: villeController,
          decoration: InputDecoration(labelText: "Ville", border: OutlineInputBorder()),
          keyboardType: TextInputType.name,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demande de maintenance"),
        backgroundColor: Color(0xFF005A9C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDropdownSection(),
              SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Description complémentaire",
                  hintText: "Ajoutez des détails si nécessaire",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              _buildAdresseFields(),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: Icon(Icons.send),
                label: Text("Envoyer la demande"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Color(0xFF005A9C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
