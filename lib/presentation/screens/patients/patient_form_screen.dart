import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/strings.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/patient_model.dart';
import '../../../presentation/providers/patient_provider.dart';
import '../../../presentation/widgets/custom_app_bar.dart';
import '../../../presentation/widgets/custom_textfield.dart';
import '../../../presentation/widgets/custom_button.dart';

class PatientFormScreen extends ConsumerStatefulWidget {
  final int? patientId;

  const PatientFormScreen({super.key, this.patientId});

  @override
  ConsumerState<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends ConsumerState<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _telephoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _adresseCtrl = TextEditingController();
  DateTime? _dateNaissance;
  String? _sexe;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.patientId != null) {
      _loadPatient();
    }
  }

  Future<void> _loadPatient() async {
    final patient = await ref.read(patientRepositoryProvider).getPatientById(widget.patientId!);
    if (patient != null && mounted) {
      setState(() {
        _nomCtrl.text = patient.nom;
        _prenomCtrl.text = patient.prenom;
        _telephoneCtrl.text = patient.telephone;
        _emailCtrl.text = patient.email ?? '';
        _adresseCtrl.text = patient.adresse ?? '';
        _dateNaissance = patient.dateNaissance;
        _sexe = patient.sexe;
      });
    }
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _telephoneCtrl.dispose();
    _emailCtrl.dispose();
    _adresseCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dateNaissance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date de naissance requise')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final patient = Patient(
      id: widget.patientId,
      nom: _nomCtrl.text.trim(),
      prenom: _prenomCtrl.text.trim(),
      dateNaissance: _dateNaissance!,
      telephone: _telephoneCtrl.text.trim(),
      email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      adresse: _adresseCtrl.text.trim().isEmpty ? null : _adresseCtrl.text.trim(),
      sexe: _sexe,
    );

    if (widget.patientId == null) {
      await ref.read(patientsProvider.notifier).addPatient(patient);
    } else {
      await ref.read(patientsProvider.notifier).updatePatient(patient);
    }

    if (mounted) {
      setState(() => _isLoading = false);
      context.pop();
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateNaissance ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dateNaissance = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.patientId != null;

    return Scaffold(
      appBar: CustomAppBar(
        title: isEditing ? 'Modifier Patient' : AppStrings.nouveauPatient,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _prenomCtrl,
                label: AppStrings.prenom,
                prefixIcon: Icons.person_outline,
                validator: (v) => Validators.required(v, fieldName: 'Prenom'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _nomCtrl,
                label: AppStrings.nom,
                prefixIcon: Icons.person_outline,
                validator: (v) => Validators.required(v, fieldName: 'Nom'),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: TextEditingController(
                      text: _dateNaissance != null
                          ? DateFormat('dd/MM/yyyy').format(_dateNaissance!)
                          : '',
                    ),
                    label: AppStrings.dateNaissance,
                    prefixIcon: Icons.calendar_today,
                    validator: (v) => _dateNaissance == null ? 'Date requise' : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _telephoneCtrl,
                label: AppStrings.telephone,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: Validators.phone,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailCtrl,
                label: 'Email (optionnel)',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _adresseCtrl,
                label: 'Adresse (optionnel)',
                prefixIcon: Icons.location_on_outlined,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              _buildSexeSelector(),
              const SizedBox(height: 32),
              CustomButton(
                text: isEditing ? AppStrings.modifier : AppStrings.enregistrer,
                isLoading: _isLoading,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSexeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sexe', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Text('Homme'),
                selected: _sexe == 'M',
                onSelected: (selected) => setState(() => _sexe = selected ? 'M' : null),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ChoiceChip(
                label: const Text('Femme'),
                selected: _sexe == 'F',
                onSelected: (selected) => setState(() => _sexe = selected ? 'F' : null),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
