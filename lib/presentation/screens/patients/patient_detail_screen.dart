import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/patient_model.dart';
import '../../../presentation/providers/patient_provider.dart';
import '../../../presentation/widgets/custom_app_bar.dart';

class PatientDetailScreen extends ConsumerWidget {
  final int patientId;

  const PatientDetailScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientAsync = ref.watch(patientsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Details Patient',
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/patients/edit/$patientId'),
          ),
        ],
      ),
      body: patientAsync.when(
        data: (patients) {
          final patient = patients.firstWhere(
            (p) => p.id == patientId,
            orElse: () =>  Patient(
              nom: '',
              prenom: '',
              dateNaissance: null as DateTime,
              telephone: '',
            ),
          );
          if (patient.id == null) {
            return const Center(child: Text('Patient non trouve'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProfileHeader(patient),
                const SizedBox(height: 24),
                _buildInfoCard(patient),
                const SizedBox(height: 24),
                _buildActions(context),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  Widget _buildProfileHeader(Patient patient) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                patient.prenom.isNotEmpty ? patient.prenom[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              patient.fullName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Patient depuis \${DateFormatter.formatDate(patient.createdAt ?? DateTime.now())}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Patient patient) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.phone, 'Telephone', patient.telephone),
            const Divider(),
            _buildInfoRow(Icons.calendar_today, 'Date de naissance',
                DateFormatter.formatDate(patient.dateNaissance)),
            const Divider(),
            _buildInfoRow(Icons.email, 'Email', patient.email ?? 'Non renseigne'),
            const Divider(),
            _buildInfoRow(Icons.location_on, 'Adresse', patient.adresse ?? 'Non renseigne'),
            const Divider(),
            _buildInfoRow(Icons.person, 'Sexe',
                patient.sexe == 'M' ? 'Homme' : patient.sexe == 'F' ? 'Femme' : 'Non renseigne'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => context.push('/analyses/demande'),
            icon: const Icon(Icons.assignment_add),
            label: const Text('Nouvelle Demande'),
          ),
        ),
      ],
    );
  }
}
