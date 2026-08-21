import '../database_helper.dart';
import '../../models/patient_model.dart';

class PatientDao {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<List<Patient>> getAll() async {
    await _db.init();
    return _db.patientsBox.values
        .map((json) => Patient.fromJson(Map<String, dynamic>.from(json)))
        .toList()
      ..sort((a, b) => a.nom.compareTo(b.nom));
  }

  Future<Patient?> getById(int id) async {
    await _db.init();
    final json = _db.patientsBox.get(id);
    if (json == null) return null;
    return Patient.fromJson(Map<String, dynamic>.from(json));
  }

  Future<List<Patient>> search(String query) async {
    await _db.init();
    final lowerQuery = query.toLowerCase();
    return _db.patientsBox.values
        .map((json) => Patient.fromJson(Map<String, dynamic>.from(json)))
        .where((p) =>
            p.nom.toLowerCase().contains(lowerQuery) ||
            p.prenom.toLowerCase().contains(lowerQuery) ||
            p.telephone.contains(query))
        .toList();
  }

  Future<int> insert(Patient patient) async {
    await _db.init();
    final id = DateTime.now().millisecondsSinceEpoch;
    final json = patient.copyWith(id: id).toJson();
    await _db.patientsBox.put(id, json);
    return id;
  }

  Future<int> update(Patient patient) async {
    await _db.init();
    await _db.patientsBox.put(patient.id!, patient.toJson());
    return patient.id!;
  }

  Future<int> delete(int id) async {
    await _db.init();
    await _db.patientsBox.delete(id);
    return id;
  }

  Future<int> count() async {
    await _db.init();
    return _db.patientsBox.length;
  }
}