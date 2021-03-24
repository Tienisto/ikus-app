import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/utility/callbacks.dart';

class QuadraticButton extends StatelessWidget {

  final Callback callback;
  final IconData icon;
  final String text;
  final double width;
  final double fontSize;

  const QuadraticButton({required this.callback, required this.icon, required this.text, required this.width, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 70,
      child: OvguButton(
        callback: callback,
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, color: Colors.white),
            Text(text, style: TextStyle(fontSize: fontSize, color: Colors.white))
          ],
        )
      ),
    );
  }
}
