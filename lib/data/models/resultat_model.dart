import 'package:equatable/equatable.dart';

class Resultat extends Equatable {
  final int? id;
  final int demandeId;
  final String valeur;
  final String? unite;
  final String? commentaire;
  final bool estNormal;
  final DateTime dateResultat;
  final int? technicianId;

  const Resultat({
    this.id,
    required this.demandeId,
    required this.valeur,
    this.unite,
    this.commentaire,
    required this.estNormal,
    required this.dateResultat,
    this.technicianId,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'demande_id': demandeId,
    'valeur': valeur,
    'unite': unite,
    'commentaire': commentaire,
    'est_normal': estNormal ? 1 : 0,
    'date_resultat': dateResultat.toIso8601String(),
    'technician_id': technicianId,
  };

  factory Resultat.fromMap(Map<String, dynamic> map) => Resultat(
    id: map['id'] as int?,
    demandeId: map['demande_id'] as int,
    valeur: map['valeur'] as String,
    unite: map['unite'] as String?,
    commentaire: map['commentaire'] as String?,
    estNormal: map['est_normal'] == 1,
    dateResultat: DateTime.parse(map['date_resultat']),
    technicianId: map['technician_id'] as int?,
  );

  Resultat copyWith({
    int? id,
    int? demandeId,
    String? valeur,
    String? unite,
    String? commentaire,
    bool? estNormal,
    DateTime? dateResultat,
    int? technicianId,
  }) => Resultat(
    id: id ?? this.id,
    demandeId: demandeId ?? this.demandeId,
    valeur: valeur ?? this.valeur,
    unite: unite ?? this.unite,
    commentaire: commentaire ?? this.commentaire,
    estNormal: estNormal ?? this.estNormal,
    dateResultat: dateResultat ?? this.dateResultat,
    technicianId: technicianId ?? this.technicianId,
  );

  @override
  List<Object?> get props => [id, demandeId, valeur, estNormal];
}
