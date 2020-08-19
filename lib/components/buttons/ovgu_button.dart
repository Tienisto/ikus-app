import 'package:flutter/material.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class OvguButton extends StatelessWidget {

  final Widget child;
  final Callback callback;
  final EdgeInsets padding;

  const OvguButton({@required this.child, @required this.callback, this.padding});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: OvguColor.primary,
      shape: OvguPixels.shape,
      elevation: OvguPixels.elevation,
      padding: padding,
      onPressed: callback,
      child: child,
    );
  }
}
