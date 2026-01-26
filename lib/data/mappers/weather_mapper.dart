import 'package:meteo/data/models/city_model.dart';
import 'package:meteo/data/models/forecast_model.dart';
import 'package:meteo/data/models/weather_model.dart';
import 'package:meteo/domain/entities/city.dart';
import 'package:meteo/domain/entities/forecast.dart';
import 'package:meteo/domain/entities/weather.dart';


class WeatherMapper {
  static Weather toEntity(WeatherModel model) {
    return Weather(
      cityName: model.cityName,
      country: model.country,
      temperature: model.temperature,
      feelsLike: model.feelsLike,
      humidity: model.humidity,
      windSpeed: model.windSpeed,
      windDegree: model.windDegree,
      pressure: model.pressure,
      description: model.description,
      iconCode: model.iconCode,
      conditionId: model.conditionId,
      tempMin: model.tempMin,
      tempMax: model.tempMax,
      visibility: model.visibility,
      sunrise: model.sunrise,
      sunset: model.sunset,
      cloudiness: model.cloudiness,
      lastUpdated: model.lastUpdated,
    );
  }

  static WeatherModel toModel(Weather entity) {
    return WeatherModel(
      cityName: entity.cityName,
      country: entity.country,
      temperature: entity.temperature,
      feelsLike: entity.feelsLike,
      humidity: entity.humidity,
      windSpeed: entity.windSpeed,
      windDegree: entity.windDegree,
      pressure: entity.pressure,
      description: entity.description,
      iconCode: entity.iconCode,
      conditionId: entity.conditionId,
      tempMin: entity.tempMin,
      tempMax: entity.tempMax,
      visibility: entity.visibility,
      sunrise: entity.sunrise,
      sunset: entity.sunset,
      cloudiness: entity.cloudiness,
      lastUpdated: entity.lastUpdated,
    );
  }

  static City toCityEntity(CityModel model) {
    return City(
      id: model.id,
      name: model.name,
      country: model.country,
      state: model.state,
      latitude: model.latitude,
      longitude: model.longitude,
      population: model.population,
      isFavorite: model.isFavorite,
      lastSearched: model.lastSearched,
    );
  }

  static CityModel toCityModel(City entity) {
    return CityModel(
      id: entity.id,
      name: entity.name,
      country: entity.country,
      state: entity.state,
      latitude: entity.latitude,
      longitude: entity.longitude,
      population: entity.population,
      isFavorite: entity.isFavorite,
      lastSearched: entity.lastSearched,
    );
  }

  static Forecast toForecastEntity(ForecastModel model) {
    return Forecast(
      dateTime: model.dateTime,
      temperature: model.temperature,
      feelsLike: model.feelsLike,
      humidity: model.humidity,
      windSpeed: model.windSpeed,
      pressure: model.pressure,
      description: model.description,
      iconCode: model.iconCode,
      conditionId: model.conditionId,
      tempMin: model.tempMin,
      tempMax: model.tempMax,
      pop: model.pop,
      cloudiness: model.cloudiness,
      rainVolume: model.rainVolume,
      snowVolume: model.snowVolume,
    );
  }

  static ForecastModel toForecastModel(Forecast entity) {
    return ForecastModel(
      dateTime: entity.dateTime,
      temperature: entity.temperature,
      feelsLike: entity.feelsLike,
      humidity: entity.humidity,
      windSpeed: entity.windSpeed,
      pressure: entity.pressure,
      description: entity.description,
      iconCode: entity.iconCode,
      conditionId: entity.conditionId,
      tempMin: entity.tempMin,
      tempMax: entity.tempMax,
      pop: entity.pop,
      cloudiness: entity.cloudiness,
      rainVolume: entity.rainVolume,
      snowVolume: entity.snowVolume,
    );
  }

  static List<Weather> toWeatherEntities(List<WeatherModel> models) {
    return models.map(toEntity).toList();
  }

  static List<City> toCityEntities(List<CityModel> models) {
    return models.map(toCityEntity).toList();
  }

  static List<Forecast> toForecastEntities(List<ForecastModel> models) {
    return models.map(toForecastEntity).toList();
  }

  static List<WeatherModel> toWeatherModels(List<Weather> entities) {
    return entities.map(toModel).toList();
  }

  static List<CityModel> toCityModels(List<City> entities) {
    return entities.map(toCityModel).toList();
  }

  static List<ForecastModel> toForecastModels(List<Forecast> entities) {
    return entities.map(toForecastModel).toList();
  }
}