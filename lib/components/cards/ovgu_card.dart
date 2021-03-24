import 'package:flutter/material.dart';
import 'package:ikus_app/utility/ui.dart';

class OvguCard extends StatelessWidget {

  final Widget child;
  final Color color;
  final EdgeInsets? margin;
  final ShapeBorder shape;

  const OvguCard({required this.child, this.color = OvguColor.secondary, this.shape = OvguPixels.shape, this.margin});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: shape,
      elevation: OvguPixels.elevation,
      margin: margin,
      child: child,
    );
  }
}
