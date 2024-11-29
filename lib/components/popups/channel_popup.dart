import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ikus_app/components/checkbox_text.dart';
import 'package:ikus_app/components/popups/generic_info_popup.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/callbacks.dart';

class ChannelPopup extends StatefulWidget {

  final List<Channel> available;
  final List<Channel> selected;
  final ChannelBooleanCallback callback;

  const ChannelPopup({required this.available, required this.selected, required this.callback});

  @override
  _ChannelPopupState createState() => _ChannelPopupState();

  static double calculateHeight(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return min(height - 300, 500);
  }
}

class _ChannelPopupState extends State<ChannelPopup> {

  static const bool DEFAULT_STATE = false;
  Map<int, bool> selectedMap = Map();

  @override
  void initState() {
    super.initState();
    widget.selected.forEach((channel) {
      selectedMap[channel.id] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GenericInfoPopup(
        title: t.popups.channel.title,
        child: ListView(
          padding: EdgeInsets.only(top: 10, bottom: 20),
          physics: Adaptive.getScrollPhysics(),
          children: widget.available.map((channel) {
            return CheckBoxText(
              text: channel.name,
              value: selectedMap[channel.id] ?? DEFAULT_STATE,
              callback: (selected) async {
                await widget.callback(channel, selected!);
                setState(() {
                  selectedMap[channel.id] = selected;
                });
              },
            );
          }).toList(),
        )
    );
  }
}
