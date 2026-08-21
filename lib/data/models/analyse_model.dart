import 'package:equatable/equatable.dart';

class Analyse extends Equatable {
  final int? id;
  final String nom;
  final String categorie;
  final double prix;
  final int delaiHeures;
  final String? description;
  final String? normes;

  const Analyse({
    this.id,
    required this.nom,
    required this.categorie,
    required this.prix,
    required this.delaiHeures,
    this.description,
    this.normes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'categorie': categorie,
    'prix': prix,
    'delai_heures': delaiHeures,
    'description': description,
    'normes': normes,
  };

  factory Analyse.fromJson(Map<String, dynamic> json) => Analyse(
    id: json['id'] as int?,
    nom: json['nom'] as String,
    categorie: json['categorie'] as String,
    prix: (json['prix'] as num).toDouble(),
    delaiHeures: json['delai_heures'] as int,
    description: json['description'] as String?,
    normes: json['normes'] as String?,
  );

  Analyse copyWith({
    int? id,
    String? nom,
    String? categorie,
    double? prix,
    int? delaiHeures,
    String? description,
    String? normes,
  }) => Analyse(
    id: id ?? this.id,
    nom: nom ?? this.nom,
    categorie: categorie ?? this.categorie,
    prix: prix ?? this.prix,
    delaiHeures: delaiHeures ?? this.delaiHeures,
    description: description ?? this.description,
    normes: normes ?? this.normes,
  );

  @override
  List<Object?> get props => [id, nom, categorie, prix];
}