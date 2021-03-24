import 'package:flutter/material.dart';
import 'package:ikus_app/utility/ui.dart';

class AnimatedProgressBar extends StatefulWidget {

  final double progress;
  final Color backgroundColor;
  final Duration reactDuration;

  const AnimatedProgressBar({required this.progress, required this.reactDuration, required this.backgroundColor});

  @override
  _AnimatedProgressBarState createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _animationProgress;
  double _progress = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.reactDuration,
    )..addListener(() {
      setState(() {
        _progress = _animationProgress.value;
      });
    });
  }

  @override
  void didUpdateWidget(AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    _animationProgress = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress
    ).animate(CurvedAnimation(
        curve: Curves.easeInOutCubic,
        parent: _animationController
    ));

    _animationController.forward(from: 0);
  }


  @override
  void dispose() {
    _animationController.dispose(); // must be before super.dispose()
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: OvguPixels.borderRadius,
      child: LinearProgressIndicator(
          minHeight: 15,
          value: _progress,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          backgroundColor: widget.backgroundColor
      ),
    );
  }
}
