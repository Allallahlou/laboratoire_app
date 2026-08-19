import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/analyse_model.dart';
import '../../domain/repositories/analyse_repository.dart';

class AnalyseNotifier extends StateNotifier<AsyncValue<List<Analyse>>> {
  final AnalyseRepository _repository;

  AnalyseNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadAnalyses();
  }

  Future<void> loadAnalyses() async {
    state = const AsyncValue.loading();
    try {
      final analyses = await _repository.getAllAnalyses();
      state = AsyncValue.data(analyses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final analyseRepositoryProvider = Provider<AnalyseRepository>((ref) => AnalyseRepository());
final analysesProvider = StateNotifierProvider<AnalyseNotifier, AsyncValue<List<Analyse>>>((ref) {
  return AnalyseNotifier(ref.watch(analyseRepositoryProvider));
});
