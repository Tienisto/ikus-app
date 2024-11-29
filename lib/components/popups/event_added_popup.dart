import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/popups/generic_confirm_popup.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/utility/callbacks.dart';

class EventAddedPopup extends StatelessWidget {

  final Event event;
  final Callback onOk;
  final Callback onUndo;
  final Callback onShowList;

  const EventAddedPopup({required this.event, required this.onOk, required this.onUndo, required this.onShowList});

  @override
  Widget build(BuildContext context) {
    return GenericConfirmPopup(
        title: t.popups.eventAdded.title,
        info: t.popups.eventAdded.content(event: event.name),
        buttons: [
          OvguButton(
            flat: true,
            callback: () {
              Navigator.pop(context);
              onUndo();
            },
            child: Text(t.popups.eventAdded.undo),
          ),
          OvguButton(
            flat: true,
            callback: () {
              Navigator.pop(context);
              onShowList();
            },
            child: Text(t.popups.eventAdded.list),
          ),
          OvguButton(
            padding: EdgeInsets.symmetric(horizontal: 30),
            callback: () {
              Navigator.pop(context);
              onOk();
            },
            child: Text(t.popups.eventAdded.ok, style: TextStyle(color: Colors.white)),
          )
        ]
    );
  }
}
