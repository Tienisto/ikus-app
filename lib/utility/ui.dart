import 'package:flutter/material.dart';

class OvguColor {

  static const Color primary = Color(0xff7a003f);
  static const Color primaryDarken = Color(0xff3d0020);
  static const Color secondary = Color(0xffe0e2e3);
  static const Color secondaryDarken1 = Color(0xffc9cdcf);
  static const Color secondaryDarken2 = Color(0xff99a0a3);
}

class OvguPixels {

  static const double maxWidth = 550;
  static const EdgeInsets mainScreenPadding = EdgeInsets.symmetric(horizontal: 20);
  static const double headerSize = 20, headerDistance = 10;

  static const double borderRadiusPlain = 15;
  static const double borderRadiusImagePlain = 5;
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(borderRadiusPlain));
  static const BorderRadius borderRadiusImage = BorderRadius.all(Radius.circular(borderRadiusImagePlain));
  static const double elevation = 3;
  static const OutlinedBorder shape = RoundedRectangleBorder(borderRadius: OvguPixels.borderRadius);

  static List<BoxShadow> boxShadow = [
    BoxShadow(
      color: Colors.grey.shade700.withAlpha(80),
      blurRadius: 5, // soften the shadow
      offset: Offset(
        5, // Move to right 10  horizontally
        5, // Move to bottom 10 Vertically
      ),
    )
  ];
}