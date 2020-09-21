import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/utility/ui.dart';

class Popups {

  static const double DEFAULT_HEIGHT = 270;

  static void generic({
    @required BuildContext context,
    @required Widget body,
    double height = DEFAULT_HEIGHT
  }) {
    showGeneralDialog(
      context: context,
      transitionDuration: Duration(milliseconds: 300),
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: true,
      barrierLabel: '',
      transitionBuilder: (context, a1, a2, widget) {
        final double curvedValue = Curves.easeInOutQuad.transform(1 - a1.value);
        final double width = min(MediaQuery.of(context).size.width - 2, 600);
        return Align(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(0, curvedValue * height + 5),
            child: SizedBox(
              width: width,
              height: height,
              child: OvguCard(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(OvguPixels.borderRadiusPlain), topRight: Radius.circular(OvguPixels.borderRadiusPlain))),
                child: Material(
                  type: MaterialType.transparency,
                  child: body
                )
              ),
            ),
          ),
        );
      },
      pageBuilder: (context, animation1, animation2) { return null; }
    );
  }
}