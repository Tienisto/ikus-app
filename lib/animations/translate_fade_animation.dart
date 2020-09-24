import 'package:flutter/widgets.dart';

class TranslateFadeAnimation extends StatefulWidget {

  final Widget child;
  final Offset start, end;
  final Curve curve;

  final Duration duration;
  final Duration delay;
  final bool reverseAfterFinish;

  TranslateFadeAnimation({@required this.child, @required this.start, @required this.end, this.curve, @required this.duration, this.delay = const Duration(milliseconds: 0), this.reverseAfterFinish = false, key}) : super(key: key);

  @override
  TranslateFadeAnimationState createState() => TranslateFadeAnimationState();
}

class TranslateFadeAnimationState extends State<TranslateFadeAnimation> with SingleTickerProviderStateMixin {

  AnimationController animationController;
  Animation<EdgeInsets> animation;
  Animation<double> animationFade;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() => setState(() {})
    )..addStatusListener((status) {
      if(status == AnimationStatus.completed && widget.reverseAfterFinish) {
        animationController.reverse(from: 1);
      }
    });

    Offset start = widget.start;
    Offset end = widget.end;
    Tween tween = EdgeInsetsTween(
      begin: EdgeInsets.only(left: start.dx, top: start.dy),
      end: EdgeInsets.only(left: end.dx, top: end.dy)
    );

    if(widget.curve != null) {
      animation = tween.animate(CurvedAnimation(
        parent: animationController,
        curve: widget.curve
      ));
    } else {
      animation = tween.animate(animationController);
    }

    Tween fadeTween = Tween<double>(
      begin: 0.0,
      end: 1.0
    );

    animationFade = fadeTween.animate(CurvedAnimation(
        curve: widget.curve ?? Curves.linear,
        parent: animationController
    ));

    Future.delayed(widget.delay, () {
      if(!mounted) return;
      animationController.forward();
    });
  }

  void startAnimation() {
    animationController.forward(from: 0);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(animation.value.left, animation.value.top),
      child: FadeTransition(
        opacity: animationFade,
        child: widget.child
      ),
    );
  }
}
