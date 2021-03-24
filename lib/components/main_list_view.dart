import 'package:flutter/material.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/ui.dart';

class MainListView extends StatelessWidget {

  final List<Widget> children;
  final EdgeInsets? padding;
  final CrossAxisAlignment crossAxisAlignment;
  final ScrollPhysics? scrollPhysics;

  const MainListView({required this.children, this.padding, this.crossAxisAlignment = CrossAxisAlignment.start, this.scrollPhysics});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: scrollPhysics ?? Adaptive.getScrollPhysics(),
      padding: padding,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 0, maxWidth: OvguPixels.maxWidth),
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              children: children,
            ),
          ),
        )
      ],
    );
  }
}
