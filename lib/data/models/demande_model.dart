import 'package:equatable/equatable.dart';
import 'patient_model.dart';
import 'analyse_model.dart';

enum StatutDemande { enAttente, enCours, terminee, annulee }

class DemandeAnalyse extends Equatable {
  final int? id;
  final int patientId;
  final int analyseId;
  final DateTime dateDemande;
  final StatutDemande statut;
  final String? notes;
  final double? montantPaye;
  final Patient? patient;
  final Analyse? analyse;

  const DemandeAnalyse({
    this.id,
    required this.patientId,
    required this.analyseId,
    required this.dateDemande,
    this.statut = StatutDemande.enAttente,
    this.notes,
    this.montantPaye,
    this.patient,
    this.analyse,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'patient_id': patientId,
    'analyse_id': analyseId,
    'date_demande': dateDemande.toIso8601String(),
    'statut': statut.name,
    'notes': notes,
    'montant_paye': montantPaye,
  };

  factory DemandeAnalyse.fromMap(Map<String, dynamic> map) => DemandeAnalyse(
    id: map['id'] as int?,
    patientId: map['patient_id'] as int,
    analyseId: map['analyse_id'] as int,
    dateDemande: DateTime.parse(map['date_demande']),
    statut: StatutDemande.values.byName(map['statut']),
    notes: map['notes'] as String?,
    montantPaye: map['montant_paye'] != null ? (map['montant_paye'] as num).toDouble() : null,
  );

  DemandeAnalyse copyWith({
    int? id,
    int? patientId,
    int? analyseId,
    DateTime? dateDemande,
    StatutDemande? statut,
    String? notes,
    double? montantPaye,
    Patient? patient,
    Analyse? analyse,
  }) => DemandeAnalyse(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    analyseId: analyseId ?? this.analyseId,
    dateDemande: dateDemande ?? this.dateDemande,
    statut: statut ?? this.statut,
    notes: notes ?? this.notes,
    montantPaye: montantPaye ?? this.montantPaye,
    patient: patient ?? this.patient,
    analyse: analyse ?? this.analyse,
  );

  @override
  List<Object?> get props => [id, patientId, analyseId, statut];
}
