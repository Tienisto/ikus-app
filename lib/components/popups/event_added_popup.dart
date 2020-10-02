import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class EventAddedPopup extends StatelessWidget {

  final Event event;
  final Callback onOk;
  final Callback onUndo;
  final Callback onShowList;

  const EventAddedPopup({@required this.event, @required this.onOk, @required this.onUndo, @required this.onShowList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Column(
        children: [
          Center(
            child: Text(t.popups.eventAddedPopup.title, style: TextStyle(color: OvguColor.primary, fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(child: Text(t.popups.eventAddedPopup.content(event: event.name), style: TextStyle(fontSize: 16), textAlign: TextAlign.center)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OvguButton(
                      flat: true,
                      callback: () {
                        Navigator.pop(context);
                        onUndo();
                      },
                      child: Text(t.popups.eventAddedPopup.undo),
                    ),
                    OvguButton(
                      flat: true,
                      callback: () {
                        Navigator.pop(context);
                        onShowList();
                      },
                      child: Text(t.popups.eventAddedPopup.list),
                    ),
                    OvguButton(
                      callback: () {
                        Navigator.pop(context);
                        onOk();
                      },
                      child: Text(t.popups.eventAddedPopup.ok, style: TextStyle(color: Colors.white)),
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
