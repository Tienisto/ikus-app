import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card_with_header.dart';
import 'package:ikus_app/model/local/background_task.dart';
import 'package:intl/intl.dart';

class BackgroundTaskLogCard extends StatelessWidget {

  static DateFormat _formatter = DateFormat("dd.MM.yyyy, HH:mm");
  static DateFormat _formatterDateOnly = DateFormat("dd.MM.yyyy");
  static DateFormat _formatterTimeOnly = DateFormat("HH:mm");
  static DateFormat _formatterTimeWithSeconds = DateFormat("HH:mm:ss");

  final BackgroundTask task;
  const BackgroundTaskLogCard(this.task);

  String timestampToStringShort(DateTime timestamp) {
    DateTime today = DateTime.now();
    if (today.day == timestamp.day && today.month == timestamp.month && today.year == timestamp.year) {
      return _formatterTimeOnly.format(timestamp);
    } else {
      return _formatter.format(timestamp);
    }
  }

  String timestampToStringVerbose(DateTime start, DateTime end) {
    return '${_formatterDateOnly.format(task.start)}, ${_formatterTimeWithSeconds.format(task.start)} - ${_formatterTimeWithSeconds.format(task.end)}';
  }

  String durationToStringShort(Duration duration) {
    return '${duration.inSeconds}s ${duration.inMilliseconds.remainder(1000)}ms';
  }

  String durationToStringVerbose(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds.remainder(60);
    int millis = duration.inMilliseconds.remainder(1000);
    String minuteString = minutes == 1 ? 'minute' : 'minutes';
    String secondsString = seconds == 1 ? 'second' : 'seconds';
    String millisString = millis == 1 ? 'millisecond' : 'milliseconds';
    return '$minutes $minuteString, $seconds $secondsString, $millis $millisString';
  }

  @override
  Widget build(BuildContext context) {
    Duration duration = task.end.difference(task.start);
    return OvguCardWithHeader(
      left: timestampToStringShort(task.start),
      right: durationToStringShort(duration),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.success ? 'SUCCESS' : 'ERROR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: task.success ? Colors.green : Colors.red)),
            SizedBox(height: 15),
            Text('Timestamp:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(timestampToStringVerbose(task.start, task.end), style: TextStyle(fontSize: 16)),
            SizedBox(height: 15),
            Text('Duration:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(durationToStringVerbose(duration), style: TextStyle(fontSize: 16)),
            SizedBox(height: 15),
            Text('Synchronized Services:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            if (task.services.isEmpty)
              Text('(None)'),
            if (task.services.isNotEmpty)
              Text(task.services.join(', ')),
          ],
        ),
      )
    );
  }
}
