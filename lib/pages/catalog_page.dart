import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/components/button_catalog.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/screens/events_screen.dart';
import 'package:ikus_app/screens/faq_screen.dart';
import 'package:ikus_app/screens/links_screen.dart';
import 'package:ikus_app/screens/map_screen.dart';
import 'package:ikus_app/screens/mensa_screen.dart';
import 'package:ikus_app/utility/ui.dart';

class CatalogPage extends StatefulWidget {
  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
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
              text: t.main.catalog.title,
            ),
          ),
          SizedBox(height: 30),
          ButtonCatalog(
            icon: Icons.calendar_today,
            text: t.main.catalog.content.events,
            favorite: true,
            callback: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => EventsScreen()));
            },
          ),
          ButtonCatalog(
            icon: Icons.language,
            text: t.main.catalog.content.links,
            favorite: false,
            callback: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => LinksScreen()));
            },
          ),
          ButtonCatalog(
            icon: Icons.map,
            text: t.main.catalog.content.map,
            favorite: true,
            callback: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => MapScreen()));
            },
          ),
          ButtonCatalog(
            icon: Icons.restaurant,
            text: t.main.catalog.content.mensa,
            favorite: true,
            callback: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => MensaScreen()));
            },
          ),
          ButtonCatalog(
            icon: Icons.help,
            text: t.main.catalog.content.faq,
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
