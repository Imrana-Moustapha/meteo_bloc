// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ForecastModelAdapter extends TypeAdapter<ForecastModel> {
  @override
  final int typeId = 3;

  @override
  ForecastModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ForecastModel(
      dateTime: fields[0] as DateTime,
      temperature: fields[1] as double,
      feelsLike: fields[2] as double,
      humidity: fields[3] as int,
      windSpeed: fields[4] as double,
      pressure: fields[5] as int,
      description: fields[6] as String,
      iconCode: fields[7] as String,
      conditionId: fields[8] as int,
      tempMin: fields[9] as double?,
      tempMax: fields[10] as double?,
      pop: fields[11] as int?,
      cloudiness: fields[12] as int?,
      rainVolume: fields[13] as double?,
      snowVolume: fields[14] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ForecastModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.temperature)
      ..writeByte(2)
      ..write(obj.feelsLike)
      ..writeByte(3)
      ..write(obj.humidity)
      ..writeByte(4)
      ..write(obj.windSpeed)
      ..writeByte(5)
      ..write(obj.pressure)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.iconCode)
      ..writeByte(8)
      ..write(obj.conditionId)
      ..writeByte(9)
      ..write(obj.tempMin)
      ..writeByte(10)
      ..write(obj.tempMax)
      ..writeByte(11)
      ..write(obj.pop)
      ..writeByte(12)
      ..write(obj.cloudiness)
      ..writeByte(13)
      ..write(obj.rainVolume)
      ..writeByte(14)
      ..write(obj.snowVolume);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForecastModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
