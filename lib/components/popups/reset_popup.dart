import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/popups/generic_confirm_popup.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/utility/callbacks.dart';

class ResetPopup extends StatelessWidget {

  final FutureCallback callback;

  const ResetPopup({@required this.callback});

  @override
  Widget build(BuildContext context) {
    return GenericConfirmPopup(
        title: t.popups.resetPopup.title,
        info: t.popups.resetPopup.content,
        buttons: [
          OvguButton(
            flat: true,
            callback: () {
              Navigator.pop(context);
            },
            child: Text(t.popups.resetPopup.cancel),
          ),
          OvguButton(
            callback: () async {
              await callback();
              Navigator.pop(context);
            },
            child: Text(t.popups.resetPopup.reset, style: TextStyle(color: Colors.white)),
          )
        ]
    );
  }
}
