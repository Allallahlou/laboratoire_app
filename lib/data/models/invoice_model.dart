import 'package:equatable/equatable.dart';

class Invoice extends Equatable {
  final int? id;
  final int demandeId;
  final String numero;
  final double montantTotal;
  final double montantPaye;
  final DateTime dateFacture;
  final bool isPaid;

  const Invoice({
    this.id,
    required this.demandeId,
    required this.numero,
    required this.montantTotal,
    required this.montantPaye,
    required this.dateFacture,
    this.isPaid = false,
  });

  double get reste => montantTotal - montantPaye;

  Map<String, dynamic> toMap() => {
    'id': id,
    'demande_id': demandeId,
    'numero': numero,
    'montant_total': montantTotal,
    'montant_paye': montantPaye,
    'date_facture': dateFacture.toIso8601String(),
    'is_paid': isPaid ? 1 : 0,
  };

  factory Invoice.fromMap(Map<String, dynamic> map) => Invoice(
    id: map['id'] as int?,
    demandeId: map['demande_id'] as int,
    numero: map['numero'] as String,
    montantTotal: (map['montant_total'] as num).toDouble(),
    montantPaye: (map['montant_paye'] as num).toDouble(),
    dateFacture: DateTime.parse(map['date_facture']),
    isPaid: map['is_paid'] == 1,
  );

  @override
  List<Object?> get props => [id, numero, montantTotal];
}
