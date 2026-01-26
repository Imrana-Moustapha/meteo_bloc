import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String id;
  final String name;
  final String country;
  final String? state;
  final double latitude;
  final double longitude;
  final int population;
  final bool isFavorite;
  final DateTime? lastSearched;

  const City({
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

  String get fullName {
    if (state != null && state!.isNotEmpty) {
      return '$name, $state, $country';
    }
    return '$name, $country';
  }

  String get shortName {
    if (state != null && state!.isNotEmpty) {
      return '$name, $state';
    }
    return '$name';
  }

  String get locationString => '$latitude,$longitude';

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

  City copyWith({
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
    return City(
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

  City toggleFavorite() {
    return copyWith(isFavorite: !isFavorite);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is City && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}