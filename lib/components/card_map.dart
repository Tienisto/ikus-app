import 'package:flutter/material.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class CardMap extends StatelessWidget {

  final Image image;
  final Callback callback;

  const CardMap({@required this.image, @required this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      borderRadius: OvguPixels.borderRadius,
      child: Card(
        color: OvguColor.secondary,
        shape: OvguPixels.shape,
        elevation: OvguPixels.elevation,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ClipRRect(
              borderRadius: OvguPixels.borderRadius,
              child: image
          ),
        ),
      ),
    );
  }
}
