import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/popups/generic_confirm_popup.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/utility/popups.dart';

class ErrorPopup extends StatelessWidget {

  static void open(BuildContext context) {
    Popups.generic(
        context: context,
        height: 150,
        body: ErrorPopup()
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericConfirmPopup(
      title: t.popups.error.title,
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
