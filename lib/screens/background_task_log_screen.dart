import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/background_task_log_card.dart';
import 'package:ikus_app/model/local/background_task.dart';
import 'package:ikus_app/service/persistent_service.dart';
import 'package:ikus_app/utility/ui.dart';

class BackgroundTaskLogScreen extends StatelessWidget {

  final List<BackgroundTask> tasks = PersistentService.instance.getBackgroundTasks().reversed.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
        title: Text('Background Tasks')
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 0, maxWidth: OvguPixels.maxWidth),
          child: ListView.builder(
            itemCount: tasks.length + 2,
            itemBuilder: (context, index) {
              if (index > 0 && index-1 < tasks.length) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: BackgroundTaskLogCard(tasks[index - 1]),
                );
              } else {
                return SizedBox(height: 30); // pre + post widget
              }
            }
          ),
        ),
      ),
    );
  }
}
