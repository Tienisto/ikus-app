import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/model/post_group.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class FAQGroupCard extends StatefulWidget {

  final PostGroup postGroup;
  final PostCallback postCallback;

  const FAQGroupCard({required this.postGroup, required this.postCallback});

  @override
  _FAQGroupCardState createState() => _FAQGroupCardState();
}

class _FAQGroupCardState extends State<FAQGroupCard> {

  bool open = false;

  void toggle() {
    setState(() {
      open = !open;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OvguCard(
      child: InkWell(
        customBorder: OvguPixels.shape,
        onTap: toggle,
        child: Padding(
          padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(widget.postGroup.channel.name, style: TextStyle(fontSize: 16))
                  ),
                  OvguButton(
                    flat: true,
                    child: Icon(open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.black),
                  )
                ],
              ),
              AnimatedCrossFade(
                crossFadeState: open ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 250),
                firstCurve: Curves.easeOutCubic,
                alignment: Alignment.topLeft,
                firstChild: Padding(
                  padding: const EdgeInsets.only(top: 5, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.postGroup.posts.map((post) {
                      return OvguButton(
                        callback: () {
                          widget.postCallback(post);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(post.title, style: TextStyle(color: Colors.white)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                secondChild: Container(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
