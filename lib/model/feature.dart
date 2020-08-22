import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/screens/contact_screen.dart';
import 'package:ikus_app/screens/faq_screen.dart';
import 'package:ikus_app/screens/handbook_screen.dart';
import 'package:ikus_app/screens/links_screen.dart';
import 'package:ikus_app/screens/map_screen.dart';
import 'package:ikus_app/screens/mensa_screen.dart';

enum Feature {
  MAP, MENSA, LINKS, HANDBOOK, FAQ, CONTACT
}

extension FeatureMembers on Feature {
  int get index => const {
    Feature.MAP: 0,
    Feature.MENSA: 1,
    Feature.LINKS: 2,
    Feature.HANDBOOK: 3,
    Feature.FAQ: 4,
    Feature.CONTACT: 5
  }[this];

  IconData get icon => const {
    Feature.MAP: Icons.map,
    Feature.MENSA: Icons.restaurant,
    Feature.LINKS: Icons.language,
    Feature.HANDBOOK: Icons.book,
    Feature.FAQ: Icons.help,
    Feature.CONTACT: Icons.person
  }[this];

  String get name => {
    Feature.MAP: t.main.features.content.map,
    Feature.MENSA: t.main.features.content.mensa,
    Feature.LINKS: t.main.features.content.links,
    Feature.HANDBOOK: t.main.features.content.handbook,
    Feature.FAQ: t.main.features.content.faq,
    Feature.CONTACT: t.main.features.content.contact
  }[this];

  Widget get widget => {
    Feature.MAP: MapScreen(),
    Feature.MENSA: MensaScreen(),
    Feature.LINKS: LinksScreen(),
    Feature.HANDBOOK: HandbookScreen(),
    Feature.FAQ: FAQScreen(),
    Feature.CONTACT: ContactScreen()
  }[this];
}