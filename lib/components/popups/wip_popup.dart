import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/popups/generic_confirm_popup.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/utility/popups.dart';

class WipPopup extends StatelessWidget {

  static void open(BuildContext context) {
    Popups.generic(
        context: context,
        height: 150,
        body: WipPopup()
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericConfirmPopup(
      title: t.popups.wip.title,
      buttons: [
        OvguButton(
          padding: EdgeInsets.symmetric(horizontal: 30),
          callback: () {
            Navigator.pop(context);
          },
          child: Text(t.popups.wip.ok, style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}
