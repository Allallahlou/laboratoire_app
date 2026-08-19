import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/patient_model.dart';
import '../../../presentation/providers/patient_provider.dart';
import '../../../presentation/widgets/custom_app_bar.dart';
import '../../../presentation/widgets/patient_list_tile.dart';

class PatientsListScreen extends ConsumerStatefulWidget {
  const PatientsListScreen({super.key});

  @override
  ConsumerState<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends ConsumerState<PatientsListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(patientsProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.patients),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: AppStrings.recherche,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          ref.read(patientsProvider.notifier).loadPatients();
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                ref.read(patientsProvider.notifier).search(value);
              },
            ),
          ),
          Expanded(
            child: patientsAsync.when(
              data: (patients) {
                if (patients.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.aucunResultat,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    final patient = patients[index];
                    return PatientListTile(
                      patient: patient,
                      onTap: () => context.push('/patients/detail/${patient.id}'),
                      onEdit: () => context.push('/patients/edit/${patient.id}'),
                      onDelete: () => _showDeleteDialog(context, ref, patient),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Erreur: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/patients/new'),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau'),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Patient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le patient?'),
        content: Text('Voulez-vous vraiment supprimer \${patient.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.annuler),
          ),
          TextButton(
            onPressed: () {
              ref.read(patientsProvider.notifier).deletePatient(patient.id!);
              Navigator.pop(context);
            },
            child: const Text(AppStrings.supprimer, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
