import 'package:flutter/widgets.dart';

class TranslateAnimation extends StatefulWidget {

  final Widget child;
  final Offset start, end;
  final Curve curve;

  final Duration duration;
  final Duration delay;
  final bool reverseAfterFinish;
  final bool loop;

  TranslateAnimation({@required this.child, @required this.start, @required this.end, this.curve, @required this.duration, this.delay = const Duration(milliseconds: 0), this.reverseAfterFinish = false, this.loop = false, Key key}) : super(key: key);

  @override
  TranslateAnimationState createState() => TranslateAnimationState();
}

class TranslateAnimationState extends State<TranslateAnimation> with SingleTickerProviderStateMixin {

  AnimationController animationController;
  Animation<EdgeInsets> animation;

  bool forward = true;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() => setState(() {})
    )..addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        if(forward) {
          // reached end
          if(widget.reverseAfterFinish) {
            forward = false;
            animationController.reverse(from: 1);
          } else if(widget.loop) {
            forward = true;
            animationController.forward(from: 0);
          }
        } else {
          // reached start
          if(widget.loop) {
            forward = true;
            animationController.forward(from: 0);
          }
        }
      }
      if(status == AnimationStatus.completed && widget.reverseAfterFinish) {

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
      child: widget.child,
    );
  }
}
