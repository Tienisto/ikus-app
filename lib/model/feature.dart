import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/screens/faq_screen.dart';
import 'package:ikus_app/screens/links_screen.dart';
import 'package:ikus_app/screens/map_screen.dart';
import 'package:ikus_app/screens/mensa_screen.dart';

enum Feature {
  FAQ, LINKS, MAP, MENSA
}

extension FeatureMembers on Feature {
  int get index => const {
    Feature.LINKS: 0,
    Feature.MAP: 1,
    Feature.MENSA: 2,
    Feature.FAQ: 3
  }[this];

  IconData get icon => const {
    Feature.LINKS: Icons.language,
    Feature.MAP: Icons.map,
    Feature.MENSA: Icons.restaurant,
    Feature.FAQ: Icons.help
  }[this];

  String get name => {
    Feature.LINKS: t.main.features.content.links,
    Feature.MAP: t.main.features.content.map,
    Feature.MENSA: t.main.features.content.mensa,
    Feature.FAQ: t.main.features.content.faq
  }[this];

  Widget get widget => {
    Feature.LINKS: LinksScreen(),
    Feature.MAP: MapScreen(),
    Feature.MENSA: MensaScreen(),
    Feature.FAQ: FAQScreen()
  }[this];
}