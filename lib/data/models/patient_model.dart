import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final int? id;
  final String nom;
  final String prenom;
  final DateTime dateNaissance;
  final String telephone;
  final String? email;
  final String? adresse;
  final String? sexe;
  final DateTime? createdAt;

  const Patient({
    this.id,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.telephone,
    this.email,
    this.adresse,
    this.sexe,
    this.createdAt,
  });

  String get fullName => '$prenom $nom';

  Map<String, dynamic> toMap() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'date_naissance': dateNaissance.toIso8601String(),
    'telephone': telephone,
    'email': email,
    'adresse': adresse,
    'sexe': sexe,
    'created_at': createdAt?.toIso8601String(),
  };

  factory Patient.fromMap(Map<String, dynamic> map) => Patient(
    id: map['id'] as int?,
    nom: map['nom'] as String,
    prenom: map['prenom'] as String,
    dateNaissance: DateTime.parse(map['date_naissance']),
    telephone: map['telephone'] as String,
    email: map['email'] as String?,
    adresse: map['adresse'] as String?,
    sexe: map['sexe'] as String?,
    createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
  );

  Patient copyWith({
    int? id,
    String? nom,
    String? prenom,
    DateTime? dateNaissance,
    String? telephone,
    String? email,
    String? adresse,
    String? sexe,
    DateTime? createdAt,
  }) => Patient(
    id: id ?? this.id,
    nom: nom ?? this.nom,
    prenom: prenom ?? this.prenom,
    dateNaissance: dateNaissance ?? this.dateNaissance,
    telephone: telephone ?? this.telephone,
    email: email ?? this.email,
    adresse: adresse ?? this.adresse,
    sexe: sexe ?? this.sexe,
    createdAt: createdAt ?? this.createdAt,
  );

  @override
  List<Object?> get props => [id, nom, prenom, telephone];
}
