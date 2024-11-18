import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

typedef Widget Behaviour(BuildContext context, Widget? widget);

class Adaptive {
  // removes overscroll 'waves' effect on iOS devices and resets the scale factor
  static Behaviour getBehaviour() {
    if (Platform.isAndroid) {
      return (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
            child: child!,
          );
    } else {
      return (context, child) => ScrollConfiguration(
            behavior: NoScrollOverflow(),
            child: MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)), child: child!),
          );
    }
  }

  // adds bouncing scroll effect on iOS devices
  static ScrollPhysics? getScrollPhysics() {
    return Platform.isAndroid ? null : BouncingScrollPhysics();
  }
}

class NoScrollOverflow extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
