import 'package:flutter/material.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class ButtonCatalog extends StatelessWidget {

  final Callback callback;
  final IconData icon;
  final String text;
  final bool favorite;

  const ButtonCatalog({@required this.callback, @required this.icon, @required this.text, @required this.favorite});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: FlatButton(
              padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
              shape: OvguPixels.shape,
              onPressed: callback,
              child: Row(
                children: [
                  Icon(icon),
                  SizedBox(width: 20),
                  Text(text, style: TextStyle(fontSize: 20))
                ],
              )
            ),
          ),
          FlatButton(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            shape: OvguPixels.shape,
            child: Icon(favorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}