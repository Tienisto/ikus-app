import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ScreenOrientation {
  PORTRAIT,
  LANDSCAPE,
  ALL,
}

void _setOrientation(ScreenOrientation orientation) {
  List<DeviceOrientation> orientations;
  switch (orientation) {
    case ScreenOrientation.PORTRAIT:
      orientations = [
        DeviceOrientation.portraitUp,
      ];
      break;
    case ScreenOrientation.LANDSCAPE:
      orientations = [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
      break;
    case ScreenOrientation.ALL:
      orientations = [
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
      break;
  }
  SystemChrome.setPreferredOrientations(orientations);
}

class NavigatorObserverWithOrientation extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute?.settings.arguments is ScreenOrientation) {
      _setOrientation(previousRoute!.settings.arguments as ScreenOrientation);
    } else {
      // fallback
      _setOrientation(ScreenOrientation.PORTRAIT);
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.settings.arguments is ScreenOrientation) {
      _setOrientation(route.settings.arguments as ScreenOrientation);
    } else {
      _setOrientation(ScreenOrientation.PORTRAIT);
    }
  }
}