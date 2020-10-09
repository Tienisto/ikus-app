import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/utility/ui.dart';

class EventPastPopup extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Column(
        children: [
          Center(
            child: Text(t.popups.eventPastPopup.title, style: TextStyle(color: OvguColor.primary, fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(child: Text(t.popups.eventPastPopup.info, style: TextStyle(fontSize: 16), textAlign: TextAlign.center)),
                Center(
                  child: OvguButton(
                    callback: () {
                      Navigator.pop(context);
                    },
                    child: Text(t.popups.eventPastPopup.ok, style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ]
      ),
    );
  }
}
