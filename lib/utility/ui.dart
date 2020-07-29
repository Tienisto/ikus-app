import 'package:flutter/material.dart';

class OvguColor {

  static const Color primary = Color(0xff7a003f);
  static const Color primaryDarken = Color(0xff3d0020);
  static const Color secondary = Color(0xffe0e2e3);
  static const Color secondaryDarken = Color(0xff99a0a3);
}

class OvguPixels {

  static const BorderRadius borderRadius = const BorderRadius.all(Radius.circular(15));
  static const double elevation = 5;
  static const ShapeBorder shape = RoundedRectangleBorder(borderRadius: OvguPixels.borderRadius);

  static List<BoxShadow> boxShadow = [
    BoxShadow(
      color: Colors.grey[700].withAlpha(80),
      blurRadius: 5, // soften the shadow
      offset: Offset(
        5, // Move to right 10  horizontally
        5, // Move to bottom 10 Vertically
      ),
    )
  ];
}