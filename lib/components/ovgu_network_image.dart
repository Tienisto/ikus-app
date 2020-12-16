import 'package:flutter/material.dart';
import 'package:ikus_app/utility/ui.dart';

class OvguNetworkImage extends StatelessWidget {

  final String url;
  final double height;

  const OvguNetworkImage({@required this.url, @required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: OvguPixels.borderRadiusImage,
        child: Image.network(url,
          width: 2000, // always use full width
          fit: BoxFit.cover,
          frameBuilder: (context, child, frame, _) {
            if (frame == null) {
              // fallback to placeholder
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
            return child;
          }
        )
      ),
    );
  }
}
