import 'package:flutter/material.dart';
import 'package:ikus_app/model/feature.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class FeatureButton extends StatelessWidget {

  final Feature feature;
  final bool favorite;
  final Callback selectCallback;
  final Callback favoriteCallback;

  const FeatureButton({@required this.feature, @required this.favorite, @required this.selectCallback, @required this.favoriteCallback});

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
              onPressed: selectCallback,
              child: Row(
                children: [
                  Icon(feature.icon),
                  SizedBox(width: 20),
                  Text(feature.name, style: TextStyle(fontSize: 20))
                ],
              )
            ),
          ),
          FlatButton(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            shape: OvguPixels.shape,
            child: Icon(favorite ? Icons.favorite : Icons.favorite_border),
            onPressed: favoriteCallback,
          )
        ],
      ),
    );
  }
}