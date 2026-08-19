import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/patient_model.dart';

class PatientListTile extends StatelessWidget {
  final Patient patient;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PatientListTile({
    super.key,
    required this.patient,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.patient.withOpacity(0.1),
                child: Text(
                  patient.prenom.isNotEmpty ? patient.prenom[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.patient,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          patient.telephone,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          DateFormatter.formatDate(patient.dateNaissance),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Modifier')),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Supprimer', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
