import 'package:hive/hive.dart';

part 'background_task.g.dart';

@HiveType(typeId: 1)
class BackgroundTask {
  @HiveField(0)
  DateTime start;

  @HiveField(1)
  DateTime end;

  @HiveField(2)
  bool success;

  @HiveField(3)
  List<String> services;
}