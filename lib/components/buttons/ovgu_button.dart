import 'package:flutter/material.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class OvguButton extends StatelessWidget {

  final Widget child;
  final Callback callback;
  final EdgeInsets padding;
  final bool flat;

  const OvguButton({@required this.child, this.callback, this.padding, this.flat = false});

  @override
  Widget build(BuildContext context) {
    if (flat)
      return FlatButton(
        shape: OvguPixels.shape,
        padding: padding,
        onPressed: callback,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // remove margin
        child: child,
      );
    else
      return RaisedButton(
        color: OvguColor.primary,
        shape: OvguPixels.shape,
        elevation: OvguPixels.elevation,
        padding: padding,
        onPressed: callback,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // remove margin
        child: child,
      );
  }
}
