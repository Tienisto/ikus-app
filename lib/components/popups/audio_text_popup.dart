import 'package:flutter/material.dart';
import 'package:ikus_app/components/popups/generic_info_popup.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/popups.dart';

class AudioTextPopup extends StatelessWidget {

  final String name;
  final String text;

  const AudioTextPopup({required this.name, required this.text});

  static void open({required BuildContext context, required String name, required String text}) {
    final height = MediaQuery.of(context).size.height;
    Popups.generic(
        context: context,
        height: height - 200,
        body: AudioTextPopup(name: name, text: text)
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericInfoPopup(
        title: name,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
          child: ListView(
            physics: Adaptive.getScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              Text(text),
              SizedBox(height: 30),
            ],
          ),
        )
    );
  }
}
