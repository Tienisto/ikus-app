import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card_with_header.dart';
import 'package:ikus_app/model/local/background_task.dart';
import 'package:ikus_app/utility/extensions.dart';
import 'package:intl/intl.dart';

class BackgroundTaskLogCard extends StatelessWidget {

  static DateFormat _formatter = DateFormat("dd.MM.yyyy, HH:mm");
  static DateFormat _formatterDateOnly = DateFormat("dd.MM.yyyy");
  static DateFormat _formatterTimeOnly = DateFormat("HH:mm");
  static DateFormat _formatterTimeWithSeconds = DateFormat("HH:mm:ss");

  final BackgroundTask task;
  const BackgroundTaskLogCard(this.task);

  String timestampToStringShort(DateTime timestamp) {
    if (timestamp.isSameDay(DateTime.now())) {
      return _formatterTimeOnly.format(timestamp);
    } else {
      return _formatter.format(timestamp);
    }
  }

  String timestampToStringVerbose(DateTime start, DateTime end) {
    return '${_formatterDateOnly.format(task.start)}, ${_formatterTimeWithSeconds.format(task.start)} - ${_formatterTimeWithSeconds.format(task.end)}';
  }

  String durationToStringShort(Duration duration) {
    return '${duration.inSeconds} s ${duration.inMilliseconds % 1000} ms';
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
            if (task.message != null)
              ...[
                SizedBox(height: 15),
                Text('Message:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(task.message!, style: TextStyle(fontSize: 16)),
              ],
            SizedBox(height: 15),
            Text('Timestamp:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(timestampToStringVerbose(task.start, task.end), style: TextStyle(fontSize: 16)),
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
