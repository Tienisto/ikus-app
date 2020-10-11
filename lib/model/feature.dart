import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/link.dart';
import 'package:ikus_app/model/post.dart';
import 'package:ikus_app/screens/contact_screen.dart';
import 'package:ikus_app/screens/faq_screen.dart';
import 'package:ikus_app/screens/handbook_screen.dart';
import 'package:ikus_app/screens/links_screen.dart';
import 'package:ikus_app/screens/map_screen.dart';
import 'package:ikus_app/screens/mensa_screen.dart';
import 'package:ikus_app/screens/my_events_screen.dart';
import 'package:ikus_app/screens/post_screen.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/icon_map.dart';
import 'package:url_launcher/url_launcher.dart';


class Feature {
  final int id;
  final int index;
  final IconData icon;
  final String shortName;
  final String longName;
  final bool recommendedFavorite;
  final FutureWithContextCallback onOpen;

  Feature({@required this.id, @required this.index, @required this.icon, @required this.shortName, @required this.longName, @required this.recommendedFavorite, @required this.onOpen});

  static final Feature MAP = Feature(id: 0, index: 0, icon: Icons.map, shortName: t.features.map.short, longName: t.features.map.long, recommendedFavorite: false, onOpen: (context) => pushScreen(context, () => MapScreen()));
  static final Feature MY_EVENTS = Feature(id: 0, index: 0, icon: Icons.today, shortName: t.features.myEvents.short, longName: t.features.myEvents.long, recommendedFavorite: false, onOpen: (context) => pushScreen(context, () => MyEventsScreen()));
  static final Feature MENSA = Feature(id: 0, index: 0, icon: Icons.restaurant, shortName: t.features.mensa.short, longName: t.features.mensa.long, recommendedFavorite: false, onOpen: (context) => pushScreen(context, () => MensaScreen()));
  static final Feature LINKS = Feature(id: 0, index: 0, icon: Icons.language, shortName: t.features.links.short, longName: t.features.links.long, recommendedFavorite: false, onOpen: (context) => pushScreen(context, () => LinksScreen()));
  static final Feature HANDBOOK = Feature(id: 0, index: 0, icon: Icons.book, shortName: t.features.handbook.short, longName: t.features.handbook.long, recommendedFavorite: false, onOpen: (context) => pushScreen(context, () => HandbookScreen()));
  static final Feature FAQ = Feature(id: 0, index: 0, icon: Icons.help, shortName: t.features.faq.short, longName: t.features.faq.long, recommendedFavorite: false, onOpen: (context) => pushScreen(context, () => FAQScreen()));
  static final Feature CONTACTS = Feature(id: 0, index: 0, icon: Icons.person, shortName: t.features.contacts.short, longName: t.features.contacts.long, recommendedFavorite: false, onOpen: (context) => pushScreen(context, () => ContactScreen()));


  /// returns the feature with the specified index from the json map
  /// returns null if parsing failed
  static Feature fromMap(int index, Map<String, dynamic> map) {

    String nativeFeature = map['nativeFeature'];
    if (nativeFeature != null) {
      // use predefined native feature
      Feature feature;
      switch (nativeFeature) {
        case 'MAP':
          feature = MAP;
          break;
        case 'MY_EVENTS':
          feature = MY_EVENTS;
          break;
        case 'MENSA':
          feature = MENSA;
          break;
        case 'LINKS':
          feature = LINKS;
          break;
        case 'HANDBOOK':
          feature = HANDBOOK;
          break;
        case 'FAQ':
          feature = FAQ;
          break;
        case 'CONTACTS':
          feature = CONTACTS;
          break;
        default: return null;
      }

      return Feature(id: map['id'], index: index, icon: feature.icon, shortName: feature.shortName, longName: feature.longName, recommendedFavorite: map['favorite'], onOpen: feature.onOpen);

    } else {
      // custom feature

      FutureWithContextCallback onOpen;
      if (map['post'] != null) {
        onOpen = (context) => pushScreen(context, () => PostScreen(Post.fromMap(map['post'])));
      } else if (map['link'] != null) {
        Link link = Link.fromMap(map['link']);
        onOpen = (context) async => await launch(link.url);
      } else {
        return null;
      }

      return Feature(
        id: map['id'],
        index: index,
        icon: IconMap.icons[map['icon']] ?? Icons.report,
        shortName: map['name'],
        longName: map['name'],
        recommendedFavorite: map['favorite'],
        onOpen: onOpen
      );
    }
  }

  @override
  String toString() {
    return shortName;
  }
}