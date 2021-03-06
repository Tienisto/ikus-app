import 'package:flutter/material.dart';
import 'package:ikus_app/utility/ui.dart';

class Badge extends StatelessWidget {

  final String text;

  const Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: OvguColor.secondary,
        borderRadius: OvguPixels.borderRadius
      ),
      child: Text(text),
    );
  }
}
