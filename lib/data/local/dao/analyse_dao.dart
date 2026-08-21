import '../database_helper.dart';
import '../../models/analyse_model.dart';

class AnalyseDao {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<List<Analyse>> getAll() async {
    await _db.init();
    return _db.analysesBox.values
        .map((json) => Analyse.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<Analyse?> getById(int id) async {
    await _db.init();
    final json = _db.analysesBox.get(id);
    if (json == null) return null;
    return Analyse.fromJson(Map<String, dynamic>.from(json));
  }

  Future<List<Analyse>> getByCategorie(String categorie) async {
    await _db.init();
    return _db.analysesBox.values
        .map((json) => Analyse.fromJson(Map<String, dynamic>.from(json)))
        .where((a) => a.categorie == categorie)
        .toList();
  }

  Future<int> insert(Analyse analyse) async {
    await _db.init();
    final id = DateTime.now().millisecondsSinceEpoch;
    final json = analyse.copyWith(id: id).toJson();
    await _db.analysesBox.put(id, json);
    return id;
  }

  Future<int> update(Analyse analyse) async {
    await _db.init();
    await _db.analysesBox.put(analyse.id!, analyse.toJson());
    return analyse.id!;
  }

  Future<int> delete(int id) async {
    await _db.init();
    await _db.analysesBox.delete(id);
    return id;
  }
}