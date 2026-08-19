import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/patient_model.dart';
import '../../domain/repositories/patient_repository.dart';

class PatientNotifier extends StateNotifier<AsyncValue<List<Patient>>> {
  final PatientRepository _repository;

  PatientNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadPatients();
  }

  Future<void> loadPatients() async {
    state = const AsyncValue.loading();
    try {
      final patients = await _repository.getAllPatients();
      state = AsyncValue.data(patients);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      await loadPatients();
      return;
    }
    state = const AsyncValue.loading();
    try {
      final patients = await _repository.searchPatients(query);
      state = AsyncValue.data(patients);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addPatient(Patient patient) async {
    await _repository.addPatient(patient);
    await loadPatients();
  }

  Future<void> updatePatient(Patient patient) async {
    await _repository.updatePatient(patient);
    await loadPatients();
  }

  Future<void> deletePatient(int id) async {
    await _repository.deletePatient(id);
    await loadPatients();
  }
}

final patientRepositoryProvider = Provider<PatientRepository>((ref) => PatientRepository());
final patientsProvider = StateNotifierProvider<PatientNotifier, AsyncValue<List<Patient>>>((ref) {
  return PatientNotifier(ref.watch(patientRepositoryProvider));
});
final patientCountProvider = FutureProvider<int>((ref) async {
  return ref.watch(patientRepositoryProvider).countPatients();
});
