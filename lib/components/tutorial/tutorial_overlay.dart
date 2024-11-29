import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/utility/callbacks.dart';

class TutorialOverlay extends StatelessWidget {

  static const String HERO_TAG = 'ovgu-logo';
  static const double WIDTH = 270;
  static const double APPROX_HEIGHT = 250;
  static const double TOTAL_WIDTH = WIDTH + 50;
  final String text;
  final String progress;
  final Callback onSkip;
  final Callback onNext;
  final bool isLast;

  const TutorialOverlay({required this.text, required this.progress, required this.onSkip, required this.onNext, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 50, top: 50),
          child: SizedBox(
            width: WIDTH,
            child: OvguCard(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(text),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                            child: Text(progress)
                        ),
                        if (!isLast)
                          OvguButton(
                            flat: true,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            callback: onSkip,
                            child: Text(t.tutorial.skip),
                          ),
                        SizedBox(width: 10),
                        OvguButton(
                          callback: onNext,
                          child: Text(isLast ? t.tutorial.done : t.tutorial.next, style: TextStyle(color: Colors.white)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Hero(
              tag: HERO_TAG,
              child: Image.asset('assets/img/logo-512-alpha.png', width: 100)
          ),
        )
      ],
    );
  }
}
