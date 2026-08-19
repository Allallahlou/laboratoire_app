import '../repositories/patient_repository.dart';
import '../repositories/analyse_repository.dart';
import '../../data/models/demande_model.dart';

class CreateDemandeUseCase {
  final PatientRepository _patientRepo;
  final AnalyseRepository _analyseRepo;

  CreateDemandeUseCase(this._patientRepo, this._analyseRepo);

  Future<bool> call(DemandeAnalyse demande) async {
    final patient = await _patientRepo.getPatientById(demande.patientId);
    final analyse = await _analyseRepo.getAnalyseById(demande.analyseId);
    return patient != null && analyse != null;
  }
}
