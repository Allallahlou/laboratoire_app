import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../models/patient_model.dart';

class PatientDao {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<List<Patient>> getAll() async {
    final db = await _db.database;
    final maps = await db.query('patients', orderBy: 'nom ASC');
    return maps.map((m) => Patient.fromMap(m)).toList();
  }

  Future<Patient?> getById(int id) async {
    final db = await _db.database;
    final maps = await db.query('patients', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Patient.fromMap(maps.first);
    return null;
  }

  Future<List<Patient>> search(String query) async {
    final db = await _db.database;
    final maps = await db.query(
      'patients',
      where: 'nom LIKE ? OR prenom LIKE ? OR telephone LIKE ?',
      whereArgs: ['%\$query%', '%\$query%', '%\$query%'],
      orderBy: 'nom ASC',
    );
    return maps.map((m) => Patient.fromMap(m)).toList();
  }

  Future<int> insert(Patient patient) async {
    final db = await _db.database;
    return await db.insert('patients', patient.toMap());
  }

  Future<int> update(Patient patient) async {
    final db = await _db.database;
    return await db.update(
      'patients',
      patient.toMap(),
      where: 'id = ?',
      whereArgs: [patient.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _db.database;
    return await db.delete('patients', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> count() async {
    final db = await _db.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM patients');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
