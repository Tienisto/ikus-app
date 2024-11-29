import 'package:flutter/material.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/components/popups/generic_info_popup.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/utility/popups.dart';

class MensaOpeningHoursPopup extends StatelessWidget {

  final String mensa;
  final String openingHours;

  const MensaOpeningHoursPopup({required this.mensa, required this.openingHours});

  static void open({required BuildContext context, required String mensa, required String openingHours}) {
    Popups.generic(
        context: context,
        height: 150,
        body: MensaOpeningHoursPopup(mensa: mensa, openingHours: openingHours)
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericInfoPopup(
        title: t.popups.mensaOpeningHours.title,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(), // fill width
              Text(mensa, style: TextStyle(fontSize: 18)),
              SizedBox(height: 5),
              IconText(
                icon: Icons.access_time,
                text: openingHours,
                size: 18
              )
            ],
          ),
        )
    );
  }
}
