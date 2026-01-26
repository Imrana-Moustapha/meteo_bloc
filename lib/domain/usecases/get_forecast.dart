import 'package:dartz/dartz.dart';
import 'package:meteo/core/error/failures.dart';
import 'package:meteo/domain/entities/forecast.dart';
import 'package:meteo/domain/repositories/weather_repository.dart';

class GetForecast {
  final WeatherRepository repository;

  GetForecast(this.repository);

  Future<Either<Failure, List<Forecast>>> execute(String cityName) async {
    try {
      final forecasts = await repository.getForecast(cityName);
      return Right(forecasts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<Forecast>>> executeDaily(
    String cityName,
    int days,
  ) async {
    try {
      final forecasts = await repository.getDailyForecast(cityName, days);
      return Right(forecasts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}