import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../models/analyse_model.dart';

class AnalyseDao {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<List<Analyse>> getAll() async {
    final db = await _db.database;
    final maps = await db.query('analyses', orderBy: 'categorie, nom ASC');
    return maps.map((m) => Analyse.fromMap(m)).toList();
  }

  Future<Analyse?> getById(int id) async {
    final db = await _db.database;
    final maps = await db.query('analyses', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Analyse.fromMap(maps.first);
    return null;
  }

  Future<List<Analyse>> getByCategorie(String categorie) async {
    final db = await _db.database;
    final maps = await db.query(
      'analyses',
      where: 'categorie = ?',
      whereArgs: [categorie],
    );
    return maps.map((m) => Analyse.fromMap(m)).toList();
  }

  Future<int> insert(Analyse analyse) async {
    final db = await _db.database;
    return await db.insert('analyses', analyse.toMap());
  }

  Future<int> update(Analyse analyse) async {
    final db = await _db.database;
    return await db.update(
      'analyses',
      analyse.toMap(),
      where: 'id = ?',
      whereArgs: [analyse.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _db.database;
    return await db.delete('analyses', where: 'id = ?', whereArgs: [id]);
  }
}
