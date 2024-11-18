// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BackgroundTaskAdapter extends TypeAdapter<BackgroundTask> {
  @override
  final int typeId = 1;

  @override
  BackgroundTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BackgroundTask()
      ..start = fields[0] as DateTime
      ..end = fields[1] as DateTime
      ..success = fields[2] as bool
      ..message = fields[3] as String?
      ..services = (fields[4] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, BackgroundTask obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.start)
      ..writeByte(1)
      ..write(obj.end)
      ..writeByte(2)
      ..write(obj.success)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.services);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackgroundTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
