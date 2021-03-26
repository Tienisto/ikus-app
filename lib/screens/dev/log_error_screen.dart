import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card_with_header.dart';
import 'package:ikus_app/model/local/log_error.dart';
import 'package:ikus_app/service/persistent_service.dart';
import 'package:ikus_app/utility/ui.dart';
import 'package:intl/intl.dart';

class LogErrorScreen extends StatelessWidget {

  static DateFormat _formatter = DateFormat("dd.MM.yyyy, HH:mm");
  final List<LogError> errors = PersistentService.instance.getErrors().reversed.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Errors')
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 0, maxWidth: OvguPixels.maxWidth),
          child: ListView.builder(
            itemCount: errors.length + 2,
            itemBuilder: (context, index) {
              if (index > 0 && index - 1 < errors.length) {
                int i = index - 1;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: Column(
                    children: [
                      OvguCardWithHeader(
                        left: _formatter.format(errors[i].timestamp),
                        right: '',
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(errors[i].message, style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(errors[i].stacktrace ?? ''),
                            ],
                          ),
                        )
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox(height: 30); // pre or post widget
              }
            }
          ),
        ),
      ),
    );
  }
}