import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/model/contact.dart';
import 'package:ikus_app/screens/image_screen.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/open_browser.dart';
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
                    child: InkWell(
                      onTap: () {
                        pushScreen(context, () => ImageScreen(tag: contact.image!, image: Image.network(ApiService.getFileUrl(contact.image!))));
                      },
                      child: ClipRRect(
                          borderRadius: OvguPixels.borderRadiusImage,
                          child: SizedBox(
                              width: 50,
                              child: Hero(
                                tag: contact.image!,
                                child: Image.network(ApiService.getFileUrl(contact.image!))
                              )
                          )
                      ),
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
                  text: contact.place!,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  multiLine: true,
                ),
              ),
            if (contact.email != null)
              InkWell(
                onTap: () async {
                  await launchUrl(Uri(
                    scheme: 'mailto',
                    path: contact.email,
                  ));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: ATTRIBUTE_PADDING),
                  child: IconText(
                    size: ATTRIBUTE_SIZE,
                    distance: ICON_TEXT_DISTANCE,
                    icon: Icons.email,
                    text: contact.email!,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    multiLine: true,
                  ),
                ),
              ),
            if (contact.phoneNumber != null)
              InkWell(
                onTap: () async {
                  await launchUrl(Uri(
                    scheme: 'tel',
                    path: contact.phoneNumber!.replaceAll(' ', '').replaceAll('-', '').replaceAll('/', ''),
                  ));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: ATTRIBUTE_PADDING),
                  child: IconText(
                    size: ATTRIBUTE_SIZE,
                    distance: ICON_TEXT_DISTANCE,
                    icon: Icons.phone,
                    text: contact.phoneNumber!,
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
                  text: contact.openingHours!,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  multiLine: true,
                ),
              ),
            if (contact.links.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: ATTRIBUTE_PADDING),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Icon(Icons.language, size: ATTRIBUTE_SIZE),
                    ),
                    SizedBox(width: ICON_TEXT_DISTANCE),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: contact.links.map((link) {
                          return InkWell(
                            onTap: () => openBrowser(link),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(link.replaceFirst('https://', '').replaceFirst('http://', ''), style: TextStyle(fontSize: ATTRIBUTE_SIZE), overflow: TextOverflow.fade, softWrap: false),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                )
              )
          ],
        ),
      ),
    );
  }
}
