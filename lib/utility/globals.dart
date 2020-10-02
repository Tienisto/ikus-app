import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/main.dart';
import 'package:ikus_app/service/orientation_service.dart';
import 'package:ikus_app/utility/callbacks.dart';

Future<void> sleep(int millis) async => await Future.delayed(Duration(milliseconds: millis));
void nextFrame(Callback callback) => WidgetsBinding.instance.addPostFrameCallback((_) => callback());

/// push another screen on top of the current screen
typedef Widget WidgetBuilder();
Future<void> pushScreen(BuildContext context, WidgetBuilder builder, [ScreenOrientation orientation]) async {
  if (orientation != null)
    await Navigator.push(context, CupertinoPageRoute(builder: (context) => builder(), settings: RouteSettings(arguments: orientation)));
  else
    await Navigator.push(context, CupertinoPageRoute(builder: (context) => builder()));
}

/// clears screen stack and set the screen
Future<void> setScreen(BuildContext context, WidgetBuilder builder, [ScreenOrientation orientation]) async {
  if (orientation != null)
    await Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => builder(), settings: RouteSettings(arguments: orientation)), (_) => false);
  else
    await Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => builder()), (_) => false);
}

class Globals {
  static IkusAppState ikusAppState;
}