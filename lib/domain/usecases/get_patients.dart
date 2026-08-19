import '../repositories/patient_repository.dart';
import '../../data/models/patient_model.dart';

class GetPatientsUseCase {
  final PatientRepository _repository;

  GetPatientsUseCase(this._repository);

  Future<List<Patient>> call() => _repository.getAllPatients();
}
