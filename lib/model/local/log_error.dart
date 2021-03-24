import 'package:hive/hive.dart';

part 'log_error.g.dart';

@HiveType(typeId: 2)
class LogError {
  @HiveField(0)
  late DateTime timestamp;

  @HiveField(1)
  late String message;

  @HiveField(2)
  String? stacktrace;
}