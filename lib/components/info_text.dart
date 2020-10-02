import 'package:flutter/material.dart';
import 'package:ikus_app/utility/ui.dart';

class InfoText extends StatelessWidget {

  final String text;

  const InfoText(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(text, style: TextStyle(color: OvguColor.secondaryDarken2, fontStyle: FontStyle.italic), textAlign: TextAlign.center)
    );
  }
}
