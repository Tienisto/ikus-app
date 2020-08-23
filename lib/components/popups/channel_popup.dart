import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/checkbox_text.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class ChannelPopup extends StatefulWidget {

  final List<Channel> available;
  final List<Channel> selected;
  final ChannelBooleanCallback callback;

  const ChannelPopup({@required this.available, @required this.selected, @required this.callback});

  @override
  _ChannelPopupState createState() => _ChannelPopupState();

  static double calculateHeight(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return min(height - 300, 500);
  }
}

class _ChannelPopupState extends State<ChannelPopup> {

  static const bool DEFAULT_STATE = false;
  Map<int, bool> selectedMap;

  @override
  void initState() {
    super.initState();

    selectedMap = Map();
    widget.selected.forEach((channel) {
      selectedMap[channel.id] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10),
              child: Text(t.popups.channelPopup.title, style: TextStyle(color: OvguColor.primary, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              width: 60,
              child: OvguButton(
                flat: true,
                padding: EdgeInsets.symmetric(vertical: 10),
                callback: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.close),
              ),
            )
          ],
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            physics: Adaptive.getScrollPhysics(),
            children: widget.available.map((channel) {
              return CheckBoxText(
                text: channel.name,
                value: selectedMap[channel.id] ?? DEFAULT_STATE,
                callback: (selected) async {
                  await widget.callback(channel, selected);
                  setState(() {
                    selectedMap[channel.id] = selected;
                  });
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
