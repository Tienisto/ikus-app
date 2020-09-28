import 'package:flutter/material.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

enum OvguButtonType {
  NORMAL,
  ICON_WIDE,
  ICON
}

class OvguButton extends StatelessWidget {

  final Widget child;
  final Callback callback;
  final EdgeInsets padding;
  final EdgeInsets paddingOverwrite;
  final bool flat;
  final double width;
  final Color color;

  const OvguButton({@required this.child, this.callback, this.padding, this.flat = false, this.color = OvguColor.primary, OvguButtonType type = OvguButtonType.NORMAL})
      : width = type == OvguButtonType.NORMAL ? null : type == OvguButtonType.ICON_WIDE ? 60 : 40, paddingOverwrite = type == OvguButtonType.ICON ? EdgeInsets.zero : null;

  Widget _getButton() {
    if (flat)
      return FlatButton(
        shape: OvguPixels.shape,
        padding: paddingOverwrite ?? padding,
        onPressed: callback,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // remove margin
        child: child,
      );
    else
      return RaisedButton(
        color: color,
        shape: OvguPixels.shape,
        elevation: OvguPixels.elevation,
        padding: paddingOverwrite ?? padding,
        onPressed: callback,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // remove margin
        child: child,
      );
  }

  @override
  Widget build(BuildContext context) {
    if (width != null)
      return SizedBox(
        width: width,
        child: _getButton(),
      );
    else
      return _getButton();
  }
}
