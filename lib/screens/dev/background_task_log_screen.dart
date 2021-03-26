import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/background_task_log_card.dart';
import 'package:ikus_app/components/info_text.dart';
import 'package:ikus_app/model/local/background_task.dart';
import 'package:ikus_app/service/persistent_service.dart';
import 'package:ikus_app/utility/ui.dart';

class BackgroundTaskLogScreen extends StatefulWidget {

  @override
  _BackgroundTaskLogScreenState createState() => _BackgroundTaskLogScreenState();
}

class _BackgroundTaskLogScreenState extends State<BackgroundTaskLogScreen> {

  List<BackgroundTask> tasks = [];
  String avgInterval = '';
  String avgDuration = '';

  @override
  void initState() {
    super.initState();
    PersistentService.instance.getBackgroundTasks().then((result) {
      setState(() {
        tasks = result.reversed.toList();
        avgInterval = durationToStringLarge(averageInterval(tasks));
        avgDuration = durationToStringSmall(averageDuration(tasks));
      });
    });
  }

  String durationToStringLarge(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    return '$hours h $minutes min';
  }

  String durationToStringSmall(Duration duration) {
    int seconds = duration.inSeconds;
    int millis = duration.inMilliseconds % 1000;
    return '$seconds s $millis ms';
  }

  Duration averageDuration(List<BackgroundTask> tasks) {
    if (tasks.length == 0)
      return Duration.zero;

    int millisSum = 0;
    for (BackgroundTask t in tasks) {
      millisSum += t.end.difference(t.start).inMilliseconds;
    }
    int millisAverage = (millisSum / tasks.length).round();
    return Duration(milliseconds: millisAverage);
  }

  Duration averageInterval(List<BackgroundTask> tasks) {
    if (tasks.length <= 1)
      return Duration.zero;

    int millisSum = 0;
    for (int i = 0; i < tasks.length - 1; i++) {
      millisSum += tasks[i].start.difference(tasks[i+1].start).inMilliseconds;
    }
    int millisAverage = (millisSum / (tasks.length - 1)).round();
    return Duration(milliseconds: millisAverage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Background Tasks')
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 0, maxWidth: OvguPixels.maxWidth),
          child: ListView.builder(
            itemCount: tasks.length + 2,
            itemBuilder: (context, index) {
              if (index > 0 && index - 1 < tasks.length) {
                int i = index - 1;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: Column(
                    children: [
                      BackgroundTaskLogCard(tasks[i]),
                      SizedBox(height: 20),
                      if (i + 1 < tasks.length)
                        InfoText(durationToStringLarge(tasks[i].start.difference(tasks[i+1].start)))
                    ],
                  ),
                );
              } else if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('# ${tasks.length}'),
                      Text('INT: $avgInterval'),
                      Text('DUR: $avgDuration')
                    ],
                  ),
                ); // pre widget
              } else {
                return SizedBox(height: 30); // post widget
              }
            }
          ),
        ),
      ),
    );
  }
}
