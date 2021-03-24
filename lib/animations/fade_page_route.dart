import 'package:flutter/material.dart';

class FadePageRoute extends PageRouteBuilder {

  final WidgetBuilder builder;

  FadePageRoute({required this.builder, required duration}) : super(
    transitionDuration: duration,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(begin: 0.0, end: 1.0);
      var curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.ease,
      );

      return FadeTransition(
        opacity: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}