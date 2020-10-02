import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class EventSelectedPopup extends StatelessWidget {

  final Event event;
  final Callback onOk;
  final Callback onUndo;

  const EventSelectedPopup({@required this.event, @required this.onOk, @required this.onUndo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Column(
        children: [
          Center(
            child: Text(t.popups.eventSelectedPopup.title, style: TextStyle(color: OvguColor.primary, fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(child: Text(t.popups.eventSelectedPopup.content(event: event.name), style: TextStyle(fontSize: 16), textAlign: TextAlign.center)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OvguButton(
                      flat: true,
                      callback: () {
                        onUndo();
                        Navigator.pop(context);
                      },
                      child: Text(t.popups.eventSelectedPopup.undo),
                    ),
                    OvguButton(
                      callback: () {
                        onOk();
                        Navigator.pop(context);
                      },
                      child: Text(t.popups.eventSelectedPopup.ok, style: TextStyle(color: Colors.white)),
                    )
                  ],
                )
              ],
            ),
          ),
        ]
      ),
    );
  }
}
