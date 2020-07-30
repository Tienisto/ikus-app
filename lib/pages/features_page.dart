import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/components/button_catalog.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/screens/faq_screen.dart';
import 'package:ikus_app/screens/links_screen.dart';
import 'package:ikus_app/screens/map_screen.dart';
import 'package:ikus_app/screens/mensa_screen.dart';
import 'package:ikus_app/utility/ui.dart';

class FeaturesPage extends StatefulWidget {
  @override
  _FeaturesPageState createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: IconText(
              size: OvguPixels.headerSize,
              distance: OvguPixels.headerDistance,
              icon: Icons.apps,
              text: t.main.features.title,
            ),
          ),
          SizedBox(height: 30),
          ButtonCatalog(
            icon: Icons.language,
            text: t.main.features.content.links,
            favorite: true,
            callback: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => LinksScreen()));
            },
          ),
          ButtonCatalog(
            icon: Icons.map,
            text: t.main.features.content.map,
            favorite: true,
            callback: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => MapScreen()));
            },
          ),
          ButtonCatalog(
            icon: Icons.restaurant,
            text: t.main.features.content.mensa,
            favorite: true,
            callback: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => MensaScreen()));
            },
          ),
          ButtonCatalog(
            icon: Icons.help,
            text: t.main.features.content.faq,
            favorite: false,
            callback: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => FAQScreen()));
            },
          ),
        ],
      ),
    );
  }
}
