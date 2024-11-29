import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/popups/generic_confirm_popup.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/utility/popups.dart';

class NeedUpdatePopup extends StatelessWidget {

  static Future<void> open(BuildContext context) async {
    await Popups.generic(
        context: context,
        height: 230,
        body: NeedUpdatePopup()
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericConfirmPopup(
        title: t.popups.needUpdate.title,
        info: t.popups.needUpdate.info,
        buttons: [
          OvguButton(
            padding: EdgeInsets.symmetric(horizontal: 30),
            callback: () {
              Navigator.pop(context);
            },
            child: Text(t.popups.needUpdate.ok, style: TextStyle(color: Colors.white)),
          )
        ]
    );
  }
}
