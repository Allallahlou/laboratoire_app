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

  Map<String, dynamic> toJson() => {
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

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    id: json['id'] as int?,
    nom: json['nom'] as String,
    prenom: json['prenom'] as String,
    dateNaissance: DateTime.parse(json['date_naissance']),
    telephone: json['telephone'] as String,
    email: json['email'] as String?,
    adresse: json['adresse'] as String?,
    sexe: json['sexe'] as String?,
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
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