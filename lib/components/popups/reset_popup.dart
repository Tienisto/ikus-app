import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/popups/generic_confirm_popup.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/popups.dart';

class ResetPopup extends StatelessWidget {

  final FutureCallback callback;

  const ResetPopup({required this.callback});

  static void open({required BuildContext context, required FutureCallback callback}) {
    Popups.generic(
        context: context,
        height: 220,
        body: ResetPopup(callback: callback)
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericConfirmPopup(
        title: t.popups.reset.title,
        info: t.popups.reset.content,
        buttons: [
          OvguButton(
            flat: true,
            callback: () {
              Navigator.pop(context);
            },
            child: Text(t.popups.reset.cancel),
          ),
          OvguButton(
            callback: callback,
            child: Text(t.popups.reset.reset, style: TextStyle(color: Colors.white)),
          )
        ]
    );
  }
}
