import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class ResetPopup extends StatelessWidget {

  final FutureCallback callback;

  const ResetPopup({@required this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Column(
        children: [
          Center(
            child: Text(t.popups.resetPopup.title, style: TextStyle(color: OvguColor.primary, fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(child: Text(t.popups.resetPopup.content, style: TextStyle(fontSize: 16), textAlign: TextAlign.center)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                  ],
                )
              ],
            ),
          ),
        ]
      ),
    );
  }
}
