// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_error.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LogErrorAdapter extends TypeAdapter<LogError> {
  @override
  final int typeId = 2;

  @override
  LogError read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LogError()
      ..timestamp = fields[0] as DateTime
      ..message = fields[1] as String
      ..stacktrace = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, LogError obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.stacktrace);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogErrorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
