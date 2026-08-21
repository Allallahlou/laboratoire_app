import 'package:hive_flutter/hive_flutter.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static bool _initialized = false;

  late Box<Map> _patientsBox;
  late Box<Map> _analysesBox;
  late Box<Map> _stockBox;

  DatabaseHelper._init();

  Future<void> init() async {
    if (_initialized) return;
    
    await Hive.initFlutter();
    
    _patientsBox = await Hive.openBox<Map>('patients');
    _analysesBox = await Hive.openBox<Map>('analyses');
    _stockBox = await Hive.openBox<Map>('stock');
    
    await _insertDefaultData();
    _initialized = true;
  }

  Future<void> _insertDefaultData() async {
    if (_analysesBox.isNotEmpty) return;

    final analyses = [
      {'id': 1, 'nom': 'Hemoglobine', 'categorie': 'Blood Test', 'prix': 50.0, 'delai_heures': 2, 'normes': '{"min": 12, "max": 16, "unite": "g/dL"}', 'description': 'Mesure du taux dhemoglobine'},
      {'id': 2, 'nom': 'Glycemie', 'categorie': 'Blood Test', 'prix': 40.0, 'delai_heures': 1, 'normes': '{"min": 0.7, "max": 1.1, "unite": "g/L"}', 'description': 'Mesure de la glycemie'},
      {'id': 3, 'nom': 'Uree', 'categorie': 'Blood Test', 'prix': 45.0, 'delai_heures': 2, 'normes': '{"min": 2.5, "max": 7.5, "unite": "mmol/L"}', 'description': 'Dosage de l uree sanguine'},
      {'id': 4, 'nom': 'Creatinine', 'categorie': 'Blood Test', 'prix': 50.0, 'delai_heures': 2, 'normes': '{"min": 62, "max": 106, "unite": "micromol/L"}', 'description': 'Dosage de la creatinine'},
      {'id': 5, 'nom': 'Cholesterol', 'categorie': 'Blood Test', 'prix': 60.0, 'delai_heures': 3, 'normes': '{"min": 0, "max": 2.0, "unite": "g/L"}', 'description': 'Dosage du cholesterol total'},
      {'id': 6, 'nom': 'Examen Urine', 'categorie': 'Urine Test', 'prix': 35.0, 'delai_heures': 1, 'normes': '{}', 'description': 'Analyse d urine complete'},
      {'id': 7, 'nom': 'CRP', 'categorie': 'Blood Test', 'prix': 70.0, 'delai_heures': 2, 'normes': '{"min": 0, "max": 5, "unite": "mg/L"}', 'description': 'Proteine C reactive'},
    ];

    for (final a in analyses) {
      await _analysesBox.put(a['id'], a);
    }

    final stock = [
      {'id': 1, 'nom': 'Tubes EDTA', 'categorie': 'Consommable', 'quantite': 150, 'quantite_min': 50, 'unite': 'unites'},
      {'id': 2, 'nom': 'Reactif Glucose', 'categorie': 'Reactif', 'quantite': 8, 'quantite_min': 10, 'unite': 'flacons'},
      {'id': 3, 'nom': 'Lames Microscope', 'categorie': 'Consommable', 'quantite': 200, 'quantite_min': 100, 'unite': 'boites'},
      {'id': 4, 'nom': 'Pipettes', 'categorie': 'Consommable', 'quantite': 45, 'quantite_min': 50, 'unite': 'boites'},
    ];

    for (final s in stock) {
      await _stockBox.put(s['id'], s);
    }
  }

  Box<Map> get patientsBox => _patientsBox;
  Box<Map> get analysesBox => _analysesBox;
  Box<Map> get stockBox => _stockBox;

  Future<void> close() async {
    await Hive.close();
  }
}