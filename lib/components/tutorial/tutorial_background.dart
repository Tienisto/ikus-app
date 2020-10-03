import 'package:flutter/material.dart';

class TutorialBackground extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Container(color: Colors.black),
    );
  }
}
