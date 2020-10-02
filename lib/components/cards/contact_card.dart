import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/model/contact.dart';
import 'package:ikus_app/utility/ui.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends StatelessWidget {

  static const double ATTRIBUTE_SIZE = 16;
  static const double ATTRIBUTE_PADDING = 5;
  static const double ICON_TEXT_DISTANCE = 15;
  final Contact contact;

  const ContactCard(this.contact);

  @override
  Widget build(BuildContext context) {
    return OvguCard(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (contact.image != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: ClipRRect(
                        borderRadius: OvguPixels.borderRadiusImage,
                        child: SizedBox(
                            width: 50,
                            child: contact.image
                        )
                    ),
                  ),
                Expanded(
                    child: Text(contact.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                ),
              ],
            ),
            SizedBox(height: 15),
            if (contact.place != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: ATTRIBUTE_PADDING),
                child: IconText(
                  size: ATTRIBUTE_SIZE,
                  distance: ICON_TEXT_DISTANCE,
                  icon: Icons.place,
                  text: contact.place,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  multiLine: true,
                ),
              ),
            if (contact.email != null)
              InkWell(
                onTap: () async {
                  await launch('mailto:${contact.email}');
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: ATTRIBUTE_PADDING),
                  child: IconText(
                    size: ATTRIBUTE_SIZE,
                    distance: ICON_TEXT_DISTANCE,
                    icon: Icons.email,
                    text: contact.email,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    multiLine: true,
                  ),
                ),
              ),
            if (contact.phoneNumber != null)
              InkWell(
                onTap: () async {
                  String url = 'tel:${contact.phoneNumber.replaceAll(' ', '').replaceAll('-', '').replaceAll('/', '')}';
                  if (await canLaunch(url))
                    await launch(url);
                  else
                    print('could not launch $url');
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: ATTRIBUTE_PADDING),
                  child: IconText(
                    size: ATTRIBUTE_SIZE,
                    distance: ICON_TEXT_DISTANCE,
                    icon: Icons.phone,
                    text: contact.phoneNumber,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    multiLine: true,
                  ),
                ),
              ),
            if (contact.openingHours != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: ATTRIBUTE_PADDING),
                child: IconText(
                  size: ATTRIBUTE_SIZE,
                  distance: ICON_TEXT_DISTANCE,
                  icon: Icons.access_time,
                  text: contact.openingHours,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  multiLine: true,
                ),
              )
          ],
        ),
      ),
    );
  }
}
