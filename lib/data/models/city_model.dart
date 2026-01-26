import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'city_model.g.dart';

@HiveType(typeId: 2)
class CityModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String country;
  
  @HiveField(3)
  final String? state;
  
  @HiveField(4)
  final double latitude;
  
  @HiveField(5)
  final double longitude;
  
  @HiveField(6)
  final int population;
  
  @HiveField(7)
  final bool isFavorite;
  
  @HiveField(8)
  final DateTime? lastSearched;

  const CityModel({
    required this.id,
    required this.name,
    required this.country,
    this.state,
    required this.latitude,
    required this.longitude,
    this.population = 0,
    this.isFavorite = false,
    this.lastSearched,
  });

  // Constructeur à partir de la réponse de l'API de recherche
  factory CityModel.fromSearchJson(Map<String, dynamic> json) {
    return CityModel(
      id: '${json['lat']}_${json['lon']}',
      name: json['name'],
      country: json['country'],
      state: json['state'],
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lon'] as num).toDouble(),
      population: (json['population'] as num?)?.toInt() ?? 0,
      lastSearched: DateTime.now(),
    );
  }

  // Constructeur à partir de la réponse de l'API météo
  factory CityModel.fromWeatherJson(Map<String, dynamic> json) {
    final coord = json['coord'];
    final sys = json['sys'];

    return CityModel(
      id: '${coord['lat']}_${coord['lon']}',
      name: json['name'],
      country: sys['country'],
      latitude: (coord['lat'] as num).toDouble(),
      longitude: (coord['lon'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
      'population': population,
      'isFavorite': isFavorite,
      'lastSearched': lastSearched?.toIso8601String(),
    };
  }

  // Helper pour obtenir le nom complet
  String get fullName {
    if (state != null && state!.isNotEmpty) {
      return '$name, $state, $country';
    }
    return '$name, $country';
  }

  // Helper pour obtenir le nom court
  String get shortName {
    if (state != null && state!.isNotEmpty) {
      return '$name, $state';
    }
    return '$name';
  }

  // Helper pour la localisation formatée pour l'API
  String get locationString => '$latitude,$longitude';

  // Copie avec modification
  CityModel copyWith({
    String? id,
    String? name,
    String? country,
    String? state,
    double? latitude,
    double? longitude,
    int? population,
    bool? isFavorite,
    DateTime? lastSearched,
  }) {
    return CityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      state: state ?? this.state,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      population: population ?? this.population,
      isFavorite: isFavorite ?? this.isFavorite,
      lastSearched: lastSearched ?? this.lastSearched,
    );
  }

  // Toggle du statut favori
  CityModel toggleFavorite() {
    return copyWith(isFavorite: !isFavorite);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        country,
        state,
        latitude,
        longitude,
        population,
        isFavorite,
        lastSearched,
      ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}