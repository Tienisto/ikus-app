import 'package:flutter/material.dart';
import 'package:ikus_app/service/settings_service.dart';

class NotifiedEventsScreen extends StatelessWidget {
  const NotifiedEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notified Events')
      ),
      body: ListView(
        children: [
          ...SettingsService.instance.getMyEventsNotified2h().map((eventId) {
            return ListTile(
              title: Text(eventId.toString()),
            );
          }),
        ],
      ),
    );
  }
}
