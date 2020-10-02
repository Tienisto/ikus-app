import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/screens/contact_screen.dart';
import 'package:ikus_app/screens/faq_screen.dart';
import 'package:ikus_app/screens/handbook_screen.dart';
import 'package:ikus_app/screens/links_screen.dart';
import 'package:ikus_app/screens/map_screen.dart';
import 'package:ikus_app/screens/mensa_screen.dart';
import 'package:ikus_app/screens/my_events_screen.dart';

enum Feature {
  MAP, MY_EVENTS, MENSA, LINKS, HANDBOOK, FAQ, CONTACT
}

extension FeatureMembers on Feature {
  int get index => const {
    Feature.MAP: 0,
    Feature.MY_EVENTS: 1,
    Feature.MENSA: 2,
    Feature.LINKS: 3,
    Feature.HANDBOOK: 4,
    Feature.FAQ: 5,
    Feature.CONTACT: 6
  }[this];

  IconData get icon => const {
    Feature.MAP: Icons.map,
    Feature.MY_EVENTS: Icons.today,
    Feature.MENSA: Icons.restaurant,
    Feature.LINKS: Icons.language,
    Feature.HANDBOOK: Icons.book,
    Feature.FAQ: Icons.help,
    Feature.CONTACT: Icons.person
  }[this];

  String get shortName => {
    Feature.MAP: t.features.map.short,
    Feature.MY_EVENTS: t.features.myEvents.short,
    Feature.MENSA: t.features.mensa.short,
    Feature.LINKS: t.features.links.short,
    Feature.HANDBOOK: t.features.handbook.short,
    Feature.FAQ: t.features.faq.short,
    Feature.CONTACT: t.features.contacts.short
  }[this];

  String get longName => {
    Feature.MAP: t.features.map.long,
    Feature.MY_EVENTS: t.features.myEvents.long,
    Feature.MENSA: t.features.mensa.long,
    Feature.LINKS: t.features.links.long,
    Feature.HANDBOOK: t.features.handbook.long,
    Feature.FAQ: t.features.faq.long,
    Feature.CONTACT: t.features.contacts.long
  }[this];

  Widget get widget => {
    Feature.MAP: MapScreen(),
    Feature.MY_EVENTS: MyEventsScreen(),
    Feature.MENSA: MensaScreen(),
    Feature.LINKS: LinksScreen(),
    Feature.HANDBOOK: HandbookScreen(),
    Feature.FAQ: FAQScreen(),
    Feature.CONTACT: ContactScreen()
  }[this];
}

extension FeatureParser on String {
  Feature toFeature() {
    return Feature.values.firstWhere((element) => describeEnum(element) == this, orElse: () => null);
  }
}