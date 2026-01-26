
import 'package:dartz/dartz.dart';
import 'package:meteo/core/error/failures.dart';
import 'package:meteo/domain/entities/city.dart';
import 'package:meteo/domain/repositories/weather_repository.dart';

class ManageFavorites {
  final WeatherRepository repository;

  ManageFavorites(this.repository);

  Future<Either<Failure, List<City>>> getFavorites() async {
    try {
      final favorites = await repository.getFavoriteCities();
      return Right(favorites);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> addFavorite(City city) async {
    try {
      await repository.addFavoriteCity(city);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> removeFavorite(String cityId) async {
    try {
      await repository.removeFavoriteCity(cityId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> isFavorite(String cityId) async {
    try {
      final isFavorite = await repository.isCityFavorite(cityId);
      return Right(isFavorite);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<City>>> getRecentCities() async {
    try {
      final recentCities = await repository.getRecentCities();
      return Right(recentCities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<City>>> searchCities(String query) async {
    try {
      final cities = await repository.searchCities(query);
      return Right(cities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}