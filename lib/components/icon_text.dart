import 'package:flutter/material.dart';

class IconText extends StatelessWidget {

  final double size;
  final double distance;
  final IconData icon;
  final String text;

  const IconText({@required this.size, @required this.icon, @required this.text, this.distance = 5});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: size),
        SizedBox(width: distance),
        Text(text, style: TextStyle(fontSize: size))
      ],
    );
  }
}
