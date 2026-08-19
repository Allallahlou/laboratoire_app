import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';  // ← جديد
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('laboratoire.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // ✅ جديد: تهيئة SQLite على Web
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE patients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        prenom TEXT NOT NULL,
        date_naissance TEXT NOT NULL,
        telephone TEXT NOT NULL,
        email TEXT,
        adresse TEXT,
        sexe TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE analyses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        categorie TEXT NOT NULL,
        prix REAL NOT NULL,
        delai_heures INTEGER NOT NULL,
        description TEXT,
        normes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE demandes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id INTEGER NOT NULL,
        analyse_id INTEGER NOT NULL,
        date_demande TEXT NOT NULL,
        statut TEXT NOT NULL DEFAULT 'enAttente',
        notes TEXT,
        montant_paye REAL,
        FOREIGN KEY (patient_id) REFERENCES patients (id) ON DELETE CASCADE,
        FOREIGN KEY (analyse_id) REFERENCES analyses (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE resultats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        demande_id INTEGER NOT NULL UNIQUE,
        valeur TEXT NOT NULL,
        unite TEXT,
        commentaire TEXT,
        est_normal INTEGER NOT NULL DEFAULT 1,
        date_resultat TEXT NOT NULL,
        technician_id INTEGER,
        FOREIGN KEY (demande_id) REFERENCES demandes (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE stock (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        categorie TEXT NOT NULL,
        quantite INTEGER NOT NULL DEFAULT 0,
        quantite_min INTEGER NOT NULL DEFAULT 10,
        unite TEXT,
        date_expiration TEXT,
        fournisseur TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE technicians (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        prenom TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        telephone TEXT,
        role TEXT NOT NULL DEFAULT 'technicien',
        is_active INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE paiements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        demande_id INTEGER NOT NULL,
        montant REAL NOT NULL,
        type TEXT NOT NULL DEFAULT 'espece',
        date_paiement TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (demande_id) REFERENCES demandes (id) ON DELETE CASCADE
      )
    ''');

    await _insertDefaultData(db);
  }

  Future<void> _insertDefaultData(Database db) async {
    final analyses = [
      {'nom': 'Hemoglobine', 'categorie': 'Blood Test', 'prix': 50.0, 'delai_heures': 2, 'normes': '{"min": 12, "max": 16, "unite": "g/dL"}', 'description': 'Mesure du taux dhemoglobine'},
      {'nom': 'Glycemie', 'categorie': 'Blood Test', 'prix': 40.0, 'delai_heures': 1, 'normes': '{"min": 0.7, "max": 1.1, "unite": "g/L"}', 'description': 'Mesure de la glycemie'},
      {'nom': 'Uree', 'categorie': 'Blood Test', 'prix': 45.0, 'delai_heures': 2, 'normes': '{"min": 2.5, "max": 7.5, "unite": "mmol/L"}', 'description': 'Dosage de l uree sanguine'},
      {'nom': 'Creatinine', 'categorie': 'Blood Test', 'prix': 50.0, 'delai_heures': 2, 'normes': '{"min": 62, "max": 106, "unite": "micromol/L"}', 'description': 'Dosage de la creatinine'},
      {'nom': 'Cholesterol', 'categorie': 'Blood Test', 'prix': 60.0, 'delai_heures': 3, 'normes': '{"min": 0, "max": 2.0, "unite": "g/L"}', 'description': 'Dosage du cholesterol total'},
      {'nom': 'Examen Urine', 'categorie': 'Urine Test', 'prix': 35.0, 'delai_heures': 1, 'normes': '{}', 'description': 'Analyse d urine complete'},
      {'nom': 'CRP', 'categorie': 'Blood Test', 'prix': 70.0, 'delai_heures': 2, 'normes': '{"min": 0, "max": 5, "unite": "mg/L"}', 'description': 'Proteine C reactive'},
    ];

    for (final a in analyses) {
      await db.insert('analyses', a);
    }

    final stock = [
      {'nom': 'Tubes EDTA', 'categorie': 'Consommable', 'quantite': 150, 'quantite_min': 50, 'unite': 'unites'},
      {'nom': 'Reactif Glucose', 'categorie': 'Reactif', 'quantite': 8, 'quantite_min': 10, 'unite': 'flacons'},
      {'nom': 'Lames Microscope', 'categorie': 'Consommable', 'quantite': 200, 'quantite_min': 100, 'unite': 'boites'},
      {'nom': 'Pipettes', 'categorie': 'Consommable', 'quantite': 45, 'quantite_min': 50, 'unite': 'boites'},
    ];

    for (final s in stock) {
      await db.insert('stock', s);
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}