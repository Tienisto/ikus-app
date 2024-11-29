import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/popups/generic_confirm_popup.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/popups.dart';

class EventUnregisterPopup extends StatelessWidget {

  final Callback callback;

  const EventUnregisterPopup({required this.callback});

  static void open({required BuildContext context, required Callback callback}) {
    Popups.generic(
        context: context,
        height: 180,
        body: EventUnregisterPopup(callback: callback)
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericConfirmPopup(
        title: t.popups.eventUnregister.title,
        info: t.popups.eventUnregister.info,
        buttons: [
          OvguButton(
            flat: true,
            callback: () {
              Navigator.pop(context);
            },
            child: Text(t.popups.eventUnregister.cancel),
          ),
          OvguButton(
            callback: () async {
              callback();
            },
            child: Text(t.popups.eventUnregister.delete, style: TextStyle(color: Colors.white)),
          )
        ]
    );
  }
}
