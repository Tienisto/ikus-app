import 'package:flutter/material.dart';

class IconText extends StatelessWidget {

  final double size;
  final double distance;
  final IconData icon;
  final String text;
  final Color? color;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final bool multiLine;

  const IconText({required this.size, required this.icon, required this.text, this.distance = 5, this.color, this.crossAxisAlignment = CrossAxisAlignment.center, this.mainAxisAlignment = MainAxisAlignment.start, this.multiLine = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Padding(
          padding: EdgeInsets.only(top: crossAxisAlignment == CrossAxisAlignment.start ? 2 : 0),
          child: Icon(icon, size: size, color: color),
        ),
        SizedBox(width: distance),
        Expanded(
            child: Text(text, style: TextStyle(color: color, fontSize: size), overflow: multiLine ? null : TextOverflow.fade, softWrap: multiLine ? null : false)
        )
      ],
    );
  }
}
