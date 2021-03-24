import 'package:flutter/material.dart';

class SmartAnimation extends StatefulWidget {

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve? curve;
  final bool startImmediately;
  final bool reverseAfterFinish;

  final Offset startPosition, endPosition;
  final double startOpacity, endOpacity;

  SmartAnimation({
    required this.child,
    required this.duration,
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

  late AnimationController _animationController;

  Animation<Offset>? _animationTranslate;
  Animation<double>? _animationFade;
  int? _animationStartTimestamp;

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
      final tweenTranslate = Tween<Offset>(
          begin: widget.startPosition,
          end: widget.endPosition
      );

      if(widget.curve != null) {
        _animationTranslate = tweenTranslate.animate(CurvedAnimation(
          parent: _animationController,
          curve: widget.curve!
        ));
      } else {
        _animationTranslate = tweenTranslate.animate(_animationController);
      }
    }

    if (widget.startOpacity != widget.endOpacity) {
      final tweenFade = Tween<double>(
          begin: widget.startOpacity,
          end: widget.endOpacity
      );

      if(widget.curve != null) {
        _animationFade = tweenFade.animate(CurvedAnimation(
          parent: _animationController,
          curve: widget.curve!,
        ));
      } else {
        _animationFade = tweenFade.animate(_animationController);
      }
    }

    if (widget.startImmediately) {
      startAnimation(delay: widget.delay);
    }
  }

  void startAnimation({Duration? delay}) {
    if (delay != null) {
      int myTimestamp = DateTime.now().millisecondsSinceEpoch;
      _animationController.reset();
      _animationStartTimestamp = myTimestamp;
      Future.delayed(widget.delay, () {
        if(!mounted || _animationStartTimestamp != myTimestamp) return;
        _animationController.forward(from: 0);
      });
    } else {
      _animationController.forward(from: 0);
    }
  }

  void startReverseAnimation() {
    _animationController.reverse(from: 1);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translate = _animationTranslate;
    final fade = _animationFade;
    if (translate != null && fade != null) {
      // animate position and opacity
      return AnimatedBuilder(
          animation: translate,
          builder: (BuildContext context, Widget? child) {
            return Transform.translate(
                offset: translate.value,
                child: Opacity(
                    opacity: fade.value,
                    child: widget.child
                )
            );
          },
          child: widget.child
      );
    } else if (translate != null) {
      // animate position only
      return AnimatedBuilder(
          animation: translate,
          builder: (BuildContext context, Widget? child) {
            return Transform.translate(
                offset: translate.value,
                child: widget.child
            );
          },
          child: widget.child
      );
    } else if (fade != null) {
      // animate opacity only
      return AnimatedBuilder(
          animation: fade,
          builder: (BuildContext context, Widget? child) {
            return Opacity(
                opacity: fade.value,
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
