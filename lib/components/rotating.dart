import 'package:flutter/material.dart';

class Rotating extends StatefulWidget {

  final Widget child;

  const Rotating({Key? key, required this.child}) : super(key: key);

  @override
  _RotatingState createState() => _RotatingState();
}

class _RotatingState extends State<Rotating> with TickerProviderStateMixin {

  late AnimationController rotationController;

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    rotationController.forward(from: 0); // starts the animation
    rotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        rotationController.forward(from: 0); // restarts the animation
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
        turns: Tween(begin: 1.0, end: 0.0).animate(rotationController),
        child: widget.child
    );
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }
}
