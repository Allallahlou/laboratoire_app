import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/demande_model.dart';
import '../../../presentation/providers/patient_provider.dart';
import '../../../presentation/providers/analyse_provider.dart';
import '../../../presentation/widgets/custom_app_bar.dart';
import '../../../presentation/widgets/custom_button.dart';

class DemandeFormScreen extends ConsumerStatefulWidget {
  const DemandeFormScreen({super.key});

  @override
  ConsumerState<DemandeFormScreen> createState() => _DemandeFormScreenState();
}

class _DemandeFormScreenState extends ConsumerState<DemandeFormScreen> {
  int? _selectedPatientId;
  int? _selectedAnalyseId;
  final _notesCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(patientsProvider);
    final analysesAsync = ref.watch(analysesProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Nouvelle Demande'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patient',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            patientsAsync.when(
              data: (patients) => DropdownButtonFormField<int>(
                value: _selectedPatientId,
                hint: const Text('Selectionner un patient'),
                items: patients.map((p) => DropdownMenuItem(
                  value: p.id,
                  child: Text(p.fullName),
                )).toList(),
                onChanged: (v) => setState(() => _selectedPatientId = v),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const Text('Erreur de chargement'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Analyse',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            analysesAsync.when(
              data: (analyses) => DropdownButtonFormField<int>(
                value: _selectedAnalyseId,
                hint: const Text('Selectionner une analyse'),
                items: analyses.map((a) => DropdownMenuItem(
                  value: a.id,
                  child: Text('${a.nom} - ${a.prix.toStringAsFixed(0)} DH'),
                )).toList(),
                onChanged: (v) => setState(() => _selectedAnalyseId = v),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.science_outlined),
                ),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const Text('Erreur de chargement'),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Notes (optionnel)',
                prefixIcon: Icon(Icons.note_outlined),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Creer la Demande',
              isLoading: _isLoading,
              onPressed: _selectedPatientId != null && _selectedAnalyseId != null
                  ? _submit
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demande creee avec succes')),
      );
    }
  }
}
