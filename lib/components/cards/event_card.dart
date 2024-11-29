import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class EventCard extends StatelessWidget {

  final Event event;
  final Callback callback;

  const EventCard({required this.event, required this.callback});

  @override
  Widget build(BuildContext context) {
    return OvguCard(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: InkWell(
        customBorder: OvguPixels.shape,
        onTap: callback,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(event.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.fade, softWrap: false),
              IconText(
                size: 16,
                icon: Icons.access_time,
                text: Event.formatFull(event.startTime),
              ),
              IconText(
                size: 16,
                icon: Icons.place,
                text: event.place ?? t.components.eventCard.noPlace
              )
            ],
          ),
        ),
      ),
    );
  }
}
