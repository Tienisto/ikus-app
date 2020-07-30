import 'package:flutter/material.dart';
import 'package:ikus_app/utility/ui.dart';

class Badge extends StatelessWidget {

  final String text;

  const Badge({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: OvguColor.secondary,
        borderRadius: OvguPixels.borderRadius
      ),
      child: Text(text),
    );
  }
}
