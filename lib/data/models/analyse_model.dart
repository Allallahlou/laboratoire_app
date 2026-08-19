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

  Map<String, dynamic> toMap() => {
    'id': id,
    'nom': nom,
    'categorie': categorie,
    'prix': prix,
    'delai_heures': delaiHeures,
    'description': description,
    'normes': normes,
  };

  factory Analyse.fromMap(Map<String, dynamic> map) => Analyse(
    id: map['id'] as int?,
    nom: map['nom'] as String,
    categorie: map['categorie'] as String,
    prix: (map['prix'] as num).toDouble(),
    delaiHeures: map['delai_heures'] as int,
    description: map['description'] as String?,
    normes: map['normes'] as String?,
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
