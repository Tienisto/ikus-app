import 'package:flutter/material.dart';

class IconText extends StatelessWidget {

  final double size;
  final double distance;
  final IconData icon;
  final String text;
  final Color color;

  const IconText({@required this.size, @required this.icon, @required this.text, this.distance = 5, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: size, color: color),
        SizedBox(width: distance),
        Text(text, style: TextStyle(color: color, fontSize: size))
      ],
    );
  }
}
