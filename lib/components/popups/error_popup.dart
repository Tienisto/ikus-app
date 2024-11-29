import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/popups/generic_confirm_popup.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/utility/popups.dart';

class ErrorPopup extends StatelessWidget {

  static void open(BuildContext context, {String? message}) {
    Popups.generic(
        context: context,
        height: 150,
        body: ErrorPopup(message)
    );
  }

  final String? message;
  const ErrorPopup(this.message);

  @override
  Widget build(BuildContext context) {
    return GenericConfirmPopup(
      title: message ?? t.popups.error.title,
      buttons: [
        OvguButton(
          padding: EdgeInsets.symmetric(horizontal: 30),
          callback: () {
            Navigator.pop(context);
          },
          child: Text(t.popups.error.ok, style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}
