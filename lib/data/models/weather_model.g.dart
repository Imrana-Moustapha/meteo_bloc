// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherModelAdapter extends TypeAdapter<WeatherModel> {
  @override
  final int typeId = 1;

  @override
  WeatherModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherModel(
      cityName: fields[0] as String,
      country: fields[1] as String,
      temperature: fields[2] as double,
      feelsLike: fields[3] as double,
      humidity: fields[4] as int,
      windSpeed: fields[5] as double,
      windDegree: fields[6] as int,
      pressure: fields[7] as int,
      description: fields[8] as String,
      iconCode: fields[9] as String,
      conditionId: fields[10] as int,
      tempMin: fields[11] as double?,
      tempMax: fields[12] as double?,
      visibility: fields[13] as int?,
      sunrise: fields[14] as int?,
      sunset: fields[15] as int?,
      cloudiness: fields[16] as int?,
      lastUpdated: fields[17] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.cityName)
      ..writeByte(1)
      ..write(obj.country)
      ..writeByte(2)
      ..write(obj.temperature)
      ..writeByte(3)
      ..write(obj.feelsLike)
      ..writeByte(4)
      ..write(obj.humidity)
      ..writeByte(5)
      ..write(obj.windSpeed)
      ..writeByte(6)
      ..write(obj.windDegree)
      ..writeByte(7)
      ..write(obj.pressure)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.iconCode)
      ..writeByte(10)
      ..write(obj.conditionId)
      ..writeByte(11)
      ..write(obj.tempMin)
      ..writeByte(12)
      ..write(obj.tempMax)
      ..writeByte(13)
      ..write(obj.visibility)
      ..writeByte(14)
      ..write(obj.sunrise)
      ..writeByte(15)
      ..write(obj.sunset)
      ..writeByte(16)
      ..write(obj.cloudiness)
      ..writeByte(17)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
