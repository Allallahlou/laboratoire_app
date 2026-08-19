import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../presentation/providers/analyse_provider.dart';
import '../../../presentation/widgets/custom_app_bar.dart';

class AnalysesListScreen extends ConsumerWidget {
  const AnalysesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysesAsync = ref.watch(analysesProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Analyses'),
      body: analysesAsync.when(
        data: (analyses) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: analyses.length,
          itemBuilder: (context, index) {
            final analyse = analyses[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.analyse.withOpacity(0.1),
                  child: const Icon(Icons.science, color: AppColors.analyse),
                ),
                title: Text(analyse.nom),
                subtitle: Text(analyse.categorie),
                trailing: Text(
                  '${analyse.prix.toStringAsFixed(0)} DH',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/analyses/demande'),
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle Demande'),
      ),
    );
  }
}
