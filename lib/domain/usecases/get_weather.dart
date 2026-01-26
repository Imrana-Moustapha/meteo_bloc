import 'package:dartz/dartz.dart';
import 'package:meteo/core/error/failures.dart';
import 'package:meteo/domain/entities/weather.dart';
import 'package:meteo/domain/repositories/weather_repository.dart';

class GetWeather {
  final WeatherRepository repository;

  GetWeather(this.repository);

  Future<Either<Failure, Weather>> execute(String cityName) async {
    try {
      final weather = await repository.getCurrentWeather(cityName);
      return Right(weather);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Weather>> executeByCoordinates(
    double lat,
    double lon,
  ) async {
    try {
      final weather = await repository.getWeatherByCoordinates(lat, lon);
      return Right(weather);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}