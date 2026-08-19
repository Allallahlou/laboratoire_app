import 'package:equatable/equatable.dart';

class Technician extends Equatable {
  final int? id;
  final String nom;
  final String prenom;
  final String email;
  final String? telephone;
  final String role;
  final bool isActive;

  const Technician({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.telephone,
    this.role = 'technicien',
    this.isActive = true,
  });

  String get fullName => '$prenom $nom';

  Map<String, dynamic> toMap() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'email': email,
    'telephone': telephone,
    'role': role,
    'is_active': isActive ? 1 : 0,
  };

  factory Technician.fromMap(Map<String, dynamic> map) => Technician(
    id: map['id'] as int?,
    nom: map['nom'] as String,
    prenom: map['prenom'] as String,
    email: map['email'] as String,
    telephone: map['telephone'] as String?,
    role: map['role'] as String? ?? 'technicien',
    isActive: map['is_active'] == 1,
  );

  @override
  List<Object?> get props => [id, nom, prenom, email];
}
