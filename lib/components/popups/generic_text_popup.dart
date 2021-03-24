import 'package:flutter/material.dart';
import 'package:ikus_app/utility/popups.dart';
import 'package:ikus_app/utility/ui.dart';

class GenericTextPopup extends StatelessWidget {

  static void open({required BuildContext context, required String text}) {
    Popups.generic(
        context: context,
        height: 140,
        dismissible: false,
        body: GenericTextPopup(text)
    );
  }

  final String text;
  const GenericTextPopup(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text, style: TextStyle(color: OvguColor.primary, fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    );
  }
}
