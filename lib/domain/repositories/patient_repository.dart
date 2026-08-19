import '../../data/local/dao/patient_dao.dart';
import '../../data/models/patient_model.dart';

class PatientRepository {
  final PatientDao _dao = PatientDao();

  Future<List<Patient>> getAllPatients() => _dao.getAll();
  Future<Patient?> getPatientById(int id) => _dao.getById(id);
  Future<List<Patient>> searchPatients(String query) => _dao.search(query);
  Future<int> addPatient(Patient patient) => _dao.insert(patient);
  Future<int> updatePatient(Patient patient) => _dao.update(patient);
  Future<int> deletePatient(int id) => _dao.delete(id);
  Future<int> countPatients() => _dao.count();
}
