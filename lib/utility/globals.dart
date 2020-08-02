import 'package:flutter/material.dart';
import 'package:ikus_app/main.dart';
import 'package:ikus_app/utility/callbacks.dart';

Future<void> sleep(int millis) async => await Future.delayed(Duration(milliseconds: millis));
void nextFrame(Callback callback) => WidgetsBinding.instance.addPostFrameCallback((_) => callback());

class Globals {
  static IkusAppState ikusAppState;
}