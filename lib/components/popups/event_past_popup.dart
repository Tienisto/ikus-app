import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/popups/generic_confirm_popup.dart';
import 'package:ikus_app/i18n/strings.g.dart';

class EventPastPopup extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GenericConfirmPopup(
        title: t.popups.eventPastPopup.title,
        info: t.popups.eventPastPopup.info,
        buttons: [
          OvguButton(
            callback: () {
              Navigator.pop(context);
            },
            child: Text(t.popups.eventPastPopup.ok, style: TextStyle(color: Colors.white)),
          )
        ]
    );
  }
}
