import 'package:flutter/material.dart';

class SmartAnimation extends StatefulWidget {

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool startImmediately;
  final bool reverseAfterFinish;

  final Offset startPosition, endPosition;
  final double startOpacity, endOpacity;

  SmartAnimation({
    @required this.child,
    @required this.duration,
    this.delay = const Duration(milliseconds: 0),
    this.curve,
    this.startImmediately = true,
    this.reverseAfterFinish = false,
    this.startPosition = Offset.zero,
    this.endPosition = Offset.zero,
    this.startOpacity = 1,
    this.endOpacity = 1,
    key
  }) : super(key: key);

  @override
  SmartAnimationState createState() => SmartAnimationState();
}

class SmartAnimationState extends State<SmartAnimation> with SingleTickerProviderStateMixin {

  AnimationController _animationController;

  Animation<Offset> _animationTranslate;
  Animation<double> _animationFade;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addStatusListener((status) {
      if(status == AnimationStatus.completed && widget.reverseAfterFinish) {
        _animationController.reverse(from: 1);
      }
    });

    if (widget.startPosition != widget.endPosition) {
      Tween tweenTranslate = Tween<Offset>(
          begin: widget.startPosition,
          end: widget.endPosition
      );

      if(widget.curve != null) {
        _animationTranslate = tweenTranslate.animate(CurvedAnimation(
            parent: _animationController,
            curve: widget.curve
        ));
      } else {
        _animationTranslate = tweenTranslate.animate(_animationController);
      }
    }

    if (widget.startOpacity != widget.endOpacity) {
      Tween tweenFade = Tween<double>(
          begin: widget.startOpacity,
          end: widget.endOpacity
      );

      if(widget.curve != null) {
        _animationFade = tweenFade.animate(CurvedAnimation(
            curve: widget.curve,
            parent: _animationController
        ));
      } else {
        _animationFade = tweenFade.animate(_animationController);
      }
    }

    if (widget.startImmediately) {
      Future.delayed(widget.delay, () {
        if(!mounted) return;
        startAnimation();
      });
    }
  }

  void startAnimation() {
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_animationTranslate != null && _animationFade != null) {
      // animate position and opacity
      return AnimatedBuilder(
          animation: _animationTranslate,
          builder: (BuildContext context, Widget child) {
            return Transform.translate(
                offset: _animationTranslate.value,
                child: Opacity(
                    opacity: _animationFade.value,
                    child: widget.child
                )
            );
          },
          child: widget.child
      );
    } else if (_animationTranslate != null) {
      // animate position only
      return AnimatedBuilder(
          animation: _animationTranslate,
          builder: (BuildContext context, Widget child) {
            return Transform.translate(
                offset: _animationTranslate.value,
                child: widget.child
            );
          },
          child: widget.child
      );
    } else if (_animationFade != null) {
      // animate opacity only
      return AnimatedBuilder(
          animation: _animationFade,
          builder: (BuildContext context, Widget child) {
            return Opacity(
                opacity: _animationFade.value,
                child: widget.child
            );
          },
          child: widget.child
      );
    } else {
      return widget.child;
    }
  }
}
