import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class MapPreviewCard extends StatelessWidget {

  final Image image;
  final Callback callback;
  final String tag;

  const MapPreviewCard({required this.image, required this.tag, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: callback,
        borderRadius: OvguPixels.borderRadius,
        child: OvguCard(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Hero(
              tag: tag,
              child: ClipRRect(
                  borderRadius: OvguPixels.borderRadius,
                  child: image
              ),
            ),
          ),
        ),
      ),
    );
  }
}
