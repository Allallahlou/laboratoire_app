import 'package:equatable/equatable.dart';

enum TypePaiement { espece, carte, virement, cheque }

class Paiement extends Equatable {
  final int? id;
  final int demandeId;
  final double montant;
  final TypePaiement type;
  final DateTime datePaiement;
  final String? notes;

  const Paiement({
    this.id,
    required this.demandeId,
    required this.montant,
    required this.type,
    required this.datePaiement,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'demande_id': demandeId,
    'montant': montant,
    'type': type.name,
    'date_paiement': datePaiement.toIso8601String(),
    'notes': notes,
  };

  factory Paiement.fromMap(Map<String, dynamic> map) => Paiement(
    id: map['id'] as int?,
    demandeId: map['demande_id'] as int,
    montant: (map['montant'] as num).toDouble(),
    type: TypePaiement.values.byName(map['type']),
    datePaiement: DateTime.parse(map['date_paiement']),
    notes: map['notes'] as String?,
  );

  @override
  List<Object?> get props => [id, demandeId, montant, type];
}
