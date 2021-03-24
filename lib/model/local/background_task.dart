import 'package:hive/hive.dart';

part 'background_task.g.dart';

@HiveType(typeId: 1)
class BackgroundTask {
  @HiveField(0)
  late DateTime start;

  @HiveField(1)
  late DateTime end;

  @HiveField(2)
  late bool success;

  @HiveField(3)
  String? message;

  @HiveField(4)
  late List<String> services;
}