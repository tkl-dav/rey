import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class ReparationPage extends StatefulWidget {
  const ReparationPage({Key? key}) : super(key: key);

  @override
  State<ReparationPage> createState() => _ReparationPageState();
}

class _ReparationPageState extends State<ReparationPage> {
  final TextEditingController panneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController villeController = TextEditingController();
  final TextEditingController rueController = TextEditingController();

  String? selectedCode;
  String? selectedLibelle;
  String? selectedModele;
  String? selectedType;
  String? selectedSerie;
  String? selectedCapacite;
  bool? sousGarantie;

  final String dateDemande = DateFormat('dd/MM/yyyy').format(DateTime.now());
  final String idDemande = 'REQ${Random().nextInt(999999).toString().padLeft(6, '0')}';

  final List<Map<String, String>> modelesDetail = [
    {"modele": "MSA12HRN1", "type": "Split", "serie": "AURORA", "capacite": "9000 BTU"},
    {"modele": "MSP18HRN3", "type": "Cassette", "serie": "PRO", "capacite": "12000 BTU"},
    {"modele": "MSA24HRQ1", "type": "VRV", "serie": "ELITE", "capacite": "18000 BTU"},
  ];

  final List<String> types = ["Split", "Cassette", "VRV"];
  final List<String> series = ["AURORA", "PRO", "ELITE"];
  final List<String> capacites = ["9000 BTU", "12000 BTU", "18000 BTU"];

  final List<Map<String, String>> panneList = [
    {"code": "A1", "libelle": "Erreur de communication"},
    {"code": "B4", "libelle": "Surchauffe unité intérieure"},
    {"code": "C5", "libelle": "Défaut capteur température"},
    {"code": "E7", "libelle": "Ventilateur bloqué"},
    {"code": "F3", "libelle": "Détection fuite gaz"},
  ];

  List<String> _filteredModeles() {
    return modelesDetail
        .where((item) => (selectedType == null || item['type'] == selectedType) &&
            (selectedSerie == null || item['serie'] == selectedSerie) &&
            (selectedCapacite == null || item['capacite'] == selectedCapacite))
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

  void _showPanneDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        String filter = "";
        List<Map<String, String>> filteredList = panneList;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Choisir un code panne"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: "Entrer un code (ex: A, 1...)"),
                    onChanged: (value) {
                      setState(() {
                        filter = value.toUpperCase();
                        filteredList = panneList
                            .where((item) => item["code"]!.contains(filter))
                            .toList();
                      });
                    },
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 150,
                    width: double.maxFinite,
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return ListTile(
                          title: Text("${item["code"]} - ${item["libelle"]}"),
                          onTap: () => Navigator.pop(context, item),
                        );
                      },
                    ),
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Annuler"),
                )
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedCode = result["code"];
        selectedLibelle = result["libelle"];
        panneController.text = "$selectedCode - $selectedLibelle";
      });
    }
  }

  void _submitForm() {
    if ((selectedModele == null && (selectedType == null || selectedSerie == null || selectedCapacite == null)) ||
        selectedCode == null ||
        descriptionController.text.isEmpty ||
        sousGarantie == null ||
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
            Text("Modèle: ${selectedModele ?? "Non précisé"}"),
            Text("Type: ${selectedType ?? "-"}"),
            Text("Série: ${selectedSerie ?? "-"}"),
            Text("Capacité: ${selectedCapacite ?? "-"}"),
            Text("Panne: $selectedCode - $selectedLibelle"),
            Text("Garantie: ${sousGarantie! ? "Oui" : "Non"}"),
            Text("Adresse: ${adresseController.text}, ${rueController.text}, ${villeController.text}"),
            SizedBox(height: 8),
            Text("Prix estimé: 1500 MUR", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Naviguer vers la page de paiement avec ID et infos à stocker
            },
            child: Text("Payer"),
          )
        ],
      ),
    );
  }

  Widget _buildDropdownSection() {
    final filtered = _filteredModeles();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: () => _selectFromList("Sélectionner un modèle", [...filtered, "Aucun"], (val) {
                setState(() {
                  selectedModele = val == "Aucun" ? null : val;
                  selectedType = null;
                  selectedSerie = null;
                  selectedCapacite = null;
                });
              }),
              child: Text(selectedModele ?? "Choisir un modèle (ou 'Aucun')"),
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
        if (selectedModele == null && filtered.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Wrap(
              spacing: 8,
              children: filtered.map((model) => OutlinedButton(
                onPressed: () => setState(() => selectedModele = model),
                child: Text(model),
              )).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildWarrantyRadio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("L'appareil est-il sous garantie ?"),
        Row(
          children: [
            Radio<bool>(value: true, groupValue: sousGarantie, onChanged: (val) => setState(() => sousGarantie = val)),
            Text("Oui"),
            Radio<bool>(value: false, groupValue: sousGarantie, onChanged: (val) => setState(() => sousGarantie = val)),
            Text("Non"),
          ],
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
        title: Text("Nouvelle Réparation"),
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
                controller: panneController,
                readOnly: true,
                onTap: _showPanneDialog,
                decoration: InputDecoration(
                  labelText: "Code panne",
                  hintText: "Cliquez pour choisir un code",
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              _buildWarrantyRadio(),
              SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Description de la panne",
                  hintText: "Ajoutez des détails si nécessaire",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
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
