import 'package:equatable/equatable.dart';

class StockItem extends Equatable {
  final int? id;
  final String nom;
  final String categorie;
  final int quantite;
  final int quantiteMin;
  final String? unite;
  final DateTime? dateExpiration;
  final String? fournisseur;

  const StockItem({
    this.id,
    required this.nom,
    required this.categorie,
    required this.quantite,
    required this.quantiteMin,
    this.unite,
    this.dateExpiration,
    this.fournisseur,
  });

  bool get isLowStock => quantite <= quantiteMin;

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'categorie': categorie,
    'quantite': quantite,
    'quantite_min': quantiteMin,
    'unite': unite,
    'date_expiration': dateExpiration?.toIso8601String(),
    'fournisseur': fournisseur,
  };

  factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
    id: json['id'] as int?,
    nom: json['nom'] as String,
    categorie: json['categorie'] as String,
    quantite: json['quantite'] as int,
    quantiteMin: json['quantite_min'] as int,
    unite: json['unite'] as String?,
    dateExpiration: json['date_expiration'] != null ? DateTime.parse(json['date_expiration']) : null,
    fournisseur: json['fournisseur'] as String?,
  );

  StockItem copyWith({
    int? id,
    String? nom,
    String? categorie,
    int? quantite,
    int? quantiteMin,
    String? unite,
    DateTime? dateExpiration,
    String? fournisseur,
  }) => StockItem(
    id: id ?? this.id,
    nom: nom ?? this.nom,
    categorie: categorie ?? this.categorie,
    quantite: quantite ?? this.quantite,
    quantiteMin: quantiteMin ?? this.quantiteMin,
    unite: unite ?? this.unite,
    dateExpiration: dateExpiration ?? this.dateExpiration,
    fournisseur: fournisseur ?? this.fournisseur,
  );

  @override
  List<Object?> get props => [id, nom, categorie, quantite];
}