import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/popups/generic_confirm_popup.dart';
import 'package:ikus_app/gen/strings.g.dart';

class EventPastPopup extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GenericConfirmPopup(
        title: t.popups.eventPast.title,
        info: t.popups.eventPast.info,
        buttons: [
          OvguButton(
            padding: EdgeInsets.symmetric(horizontal: 30),
            callback: () {
              Navigator.pop(context);
            },
            child: Text(t.popups.eventPast.ok, style: TextStyle(color: Colors.white)),
          )
        ]
    );
  }
}
