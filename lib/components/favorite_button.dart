import 'package:flutter/material.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class FavoriteButton extends StatelessWidget {

  final Callback callback;
  final IconData icon;
  final String text;

  const FavoriteButton({@required this.callback, @required this.icon, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 30 * 2) / 3,
      child: RaisedButton(
        color: OvguColor.primary,
        elevation: OvguPixels.elevation,
        shape: OvguPixels.shape,
        onPressed: callback,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, color: Colors.white),
            Text(text, style: TextStyle(color: Colors.white))
          ],
        )
      ),
    );
  }
}
