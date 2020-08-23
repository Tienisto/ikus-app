import 'package:flutter/material.dart';
import 'package:ikus_app/utility/adaptive.dart';

class MainListView extends StatelessWidget {

  static const double MAX_WIDTH = 550;
  final List<Widget> children;
  final EdgeInsets padding;

  const MainListView({@required this.children, this.padding});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: Adaptive.getScrollPhysics(),
      padding: padding,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 0, maxWidth: MAX_WIDTH),
            child: Column(
              children: children,
            ),
          ),
        )
      ],
    );
  }
}
