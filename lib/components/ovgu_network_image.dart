import 'package:flutter/material.dart';
import 'package:ikus_app/utility/ui.dart';

class OvguNetworkImage extends StatelessWidget {

  final String? url;
  final double height;

  /// url may be null, then the placeholder will be shown
  const OvguNetworkImage({required this.url, required this.height});

  Widget getPlaceholder() {
    return Container(
      color: OvguColor.secondaryDarken1,
      child: Center(
        child: Opacity(
          opacity: 0.1,
          child: Image.asset('assets/img/logo-512-alpha.png', height: height)
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: OvguPixels.borderRadiusImage,
        child: url == null ? getPlaceholder() : Image.network(url!,
          width: 2000, // always use full width
          fit: BoxFit.cover,
          frameBuilder: (context, child, frame, _) {
            if (frame == null) {
              // fallback to placeholder
              return getPlaceholder();
            }
            return child;
          }
        )
      ),
    );
  }
}
