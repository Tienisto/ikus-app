import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/main.dart';
import 'package:ikus_app/service/orientation_service.dart';
import 'package:ikus_app/utility/callbacks.dart';

Future<void> sleep(int millis) async => await Future.delayed(Duration(milliseconds: millis));
void nextFrame(Callback callback) => WidgetsBinding.instance.addPostFrameCallback((_) => callback());

/// push another screen on top of the current screen
typedef Widget WidgetBuilder();
void pushScreen(BuildContext context, WidgetBuilder builder, [ScreenOrientation orientation]) {
  if (orientation != null)
    Navigator.push(context, CupertinoPageRoute(builder: (context) => builder(), settings: RouteSettings(arguments: orientation)));
  else
    Navigator.push(context, CupertinoPageRoute(builder: (context) => builder()));
}

/// clears screen stack and set the screen
void setScreen(BuildContext context, WidgetBuilder builder, [ScreenOrientation orientation]) {
  if (orientation != null)
    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => builder(), settings: RouteSettings(arguments: orientation)), (_) => false);
  else
    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => builder()), (_) => false);
}

class Globals {
  static IkusAppState ikusAppState;
}