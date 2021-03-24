import 'package:flutter/material.dart';
import 'package:ikus_app/utility/ui.dart';

class TutorialFeatureHighlight extends StatefulWidget {

  final bool visible;
  final double width;
  final double height;

  const TutorialFeatureHighlight({required this.visible, required this.width, required this.height});

  @override
  _TutorialFeatureHighlightState createState() => _TutorialFeatureHighlightState();
}

class _TutorialFeatureHighlightState extends State<TutorialFeatureHighlight> {

  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    _opacity = widget.visible ? 1 : 0;
  }

  @override
  void didUpdateWidget(TutorialFeatureHighlight oldWidget) {
    super.didUpdateWidget(oldWidget);
    _opacity = widget.visible ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: 500),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: OvguPixels.borderRadius,
          border: Border.all(color: Colors.white, width: 5),
        ),
      ),
    );
  }
}
