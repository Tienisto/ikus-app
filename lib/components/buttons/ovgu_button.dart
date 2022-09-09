import 'package:flutter/material.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class OvguButton extends StatelessWidget {

  final Widget child;
  final Callback? callback;
  final EdgeInsets? padding;
  final bool flat;
  final Color color;

  const OvguButton({required this.child, this.callback, this.padding, this.flat = false, this.color = OvguColor.primary});

  @override
  Widget build(BuildContext context) {
    if (flat) {
      return ButtonTheme(
        minWidth: 0,
        child: TextButton(
          style: TextButton.styleFrom(
            padding: padding,
            shape: OvguPixels.shape,
            minimumSize: Size(50, 40),
            foregroundColor: Colors.black,
          ),
          onPressed: callback,
          child: child,
        ),
      );
    } else {
      return ButtonTheme(
        minWidth: 0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: OvguPixels.shape,
            elevation: OvguPixels.elevation,
            padding: padding,
          ),
          onPressed: callback,
          child: child,
        ),
      );
    }
  }
}
