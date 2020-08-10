import 'package:flutter/material.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class FavoriteButton extends StatelessWidget {

  final Callback callback;
  final IconData icon;
  final String text;
  final double width;
  final double fontSize;

  const FavoriteButton({@required this.callback, @required this.icon, @required this.text, @required this.width, @required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: RaisedButton(
        color: OvguColor.primary,
        elevation: OvguPixels.elevation,
        shape: OvguPixels.shape,
        onPressed: callback,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, color: Colors.white),
            Text(text, style: TextStyle(fontSize: fontSize, color: Colors.white))
          ],
        )
      ),
    );
  }
}
