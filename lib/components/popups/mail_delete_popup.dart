import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/popups/generic_confirm_popup.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/popups.dart';

class MailDeletePopup extends StatelessWidget {

  final Callback callback;

  const MailDeletePopup({required this.callback});

  static void open({required BuildContext context, required Callback callback}) {
    Popups.generic(
        context: context,
        height: 180,
        body: MailDeletePopup(callback: callback)
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericConfirmPopup(
        title: t.popups.mailDelete.title,
        info: t.popups.mailDelete.info,
        buttons: [
          OvguButton(
            flat: true,
            callback: () {
              Navigator.pop(context);
            },
            child: Text(t.popups.mailDelete.cancel),
          ),
          OvguButton(
            callback: () async {
              callback();
            },
            child: Text(t.popups.mailDelete.delete, style: TextStyle(color: Colors.white)),
          )
        ]
    );
  }
}
