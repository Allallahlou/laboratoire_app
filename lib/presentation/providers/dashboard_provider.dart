import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laboratoire_app/presentation/providers/patient_provider.dart';
import '../../data/models/patient_model.dart';
import '../../data/models/demande_model.dart';
import '../../data/models/stock_model.dart';
import '../../domain/repositories/patient_repository.dart';

class DashboardStats {
  final int totalPatients;
  final int totalDemandes;
  final int demandesEnCours;
  final double totalRevenus;
  final List<DemandeAnalyse> recentDemandes;
  final List<StockItem> stockAlerts;

  DashboardStats({
    this.totalPatients = 0,
    this.totalDemandes = 0,
    this.demandesEnCours = 0,
    this.totalRevenus = 0,
    this.recentDemandes = const [],
    this.stockAlerts = const [],
  });
}

class DashboardNotifier extends StateNotifier<AsyncValue<DashboardStats>> {
  final PatientRepository _patientRepo;

  DashboardNotifier(this._patientRepo) : super(const AsyncValue.loading()) {
    loadStats();
  }

  Future<void> loadStats() async {
    state = const AsyncValue.loading();
    try {
      final patientCount = await _patientRepo.countPatients();
      state = AsyncValue.data(DashboardStats(
        totalPatients: patientCount,
        totalDemandes: 0,
        demandesEnCours: 0,
        totalRevenus: 0,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardStats>>((ref) {
  return DashboardNotifier(ref.read(patientRepositoryProvider));
});