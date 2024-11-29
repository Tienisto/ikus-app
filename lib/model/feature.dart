// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/link.dart';
import 'package:ikus_app/model/post.dart';
import 'package:ikus_app/screens/contact_screen.dart';
import 'package:ikus_app/screens/faq_screen.dart';
import 'package:ikus_app/screens/handbook_screen.dart';
import 'package:ikus_app/screens/links_screen.dart';
import 'package:ikus_app/screens/mail_screen.dart';
import 'package:ikus_app/screens/map_screen.dart';
import 'package:ikus_app/screens/mensa_screen.dart';
import 'package:ikus_app/screens/my_events_screen.dart';
import 'package:ikus_app/screens/ovgu_account_screen.dart';
import 'package:ikus_app/screens/audio_list_screen.dart';
import 'package:ikus_app/screens/post_screen.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/icon_map.dart';
import 'package:ikus_app/utility/open_browser.dart';

class Feature {
  final int id;
  final int index;
  final IconData icon;
  final String shortName;
  final String longName;
  final bool recommendedFavorite;
  final FutureWithContextCallback onOpen;

  Feature({required this.id, required this.index, required this.icon, required FeatureName name, required this.recommendedFavorite, required this.onOpen}) : shortName = name.short, longName = name.long;

  Feature.custom({required this.id, required this.index, required this.icon, required this.shortName, required this.longName, required this.recommendedFavorite, required this.onOpen});

  static Feature get MAP => Feature(id: 0, index: 0, icon: Icons.map, name: t.features.map, recommendedFavorite: false, onOpen: (context) => pushScreen(context, () => MapScreen()));
  static Feature get MY_EVENTS => Feature(id: 0, index: 0, icon: Icons.today, name: t.features.myEvents, recommendedFavorite: false, onOpen: (context) => pushScreen(context, () => MyEventsScreen()));
  static Feature get MENSA => Feature(id: 0, index: 0, icon: Icons.restaurant, name: t.features.mensa, recommendedFavorite: false, onOpen: (context) => pushScreen(context, () => MensaScreen()));
  static Feature get LINKS => Feature(id: 0, index: 0, icon: Icons.language, name: t.features.links, recommendedFavorite: false, onOpen: (context) => pushScreen(context, () => LinksScreen()));
  static Feature get HANDBOOK => Feature(id: 0, index: 0, icon: Icons.book, name: t.features.handbook, recommendedFavorite: false, onOpen: (context) => pushScreen(context, () => HandbookScreen()));
  static Feature get AUDIO => Feature(id: 0, index: 0, icon: Icons.headset, name: t.features.audio, recommendedFavorite: false, onOpen: (context) => pushScreen(context, () => AudioListScreen()));
  static Feature get FAQ => Feature(id: 0, index: 0, icon: Icons.help, name: t.features.faq, recommendedFavorite: false, onOpen: (context) => pushScreen(context, () => FAQScreen()));
  static Feature get CONTACTS => Feature(id: 0, index: 0, icon: Icons.person, name: t.features.contacts, recommendedFavorite: false, onOpen: (context) => pushScreen(context, () => ContactScreen()));
  static Feature get EMAILS => Feature(id: 0, index: 0, icon: Icons.mail, name: t.features.emails, recommendedFavorite: false, onOpen: (context) => _pushScreenWithOvguAccount(context, () => MailScreen()));

  /// returns the feature with the specified index from the json map
  /// returns null if parsing failed
  static Feature? fromMap(int index, Map<String, dynamic> map) {

    String? nativeFeature = map['nativeFeature'];
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
        case 'AUDIO':
          feature = AUDIO;
          break;
        case 'FAQ':
          feature = FAQ;
          break;
        case 'CONTACTS':
          feature = CONTACTS;
          break;
        case 'EMAILS':
          feature = EMAILS;
          break;
        default: return null;
      }

      return feature.withServerData(id: map['id'], index: index, favorite: map['favorite']);

    } else {
      // custom feature

      FutureWithContextCallback onOpen;
      if (map['post'] != null) {
        onOpen = (context) => pushScreen(context, () => PostScreen(Post.fromMap(map['post'])));
      } else if (map['link'] != null) {
        final link = Link.fromMap(map['link']);
        onOpen = (context) => openBrowser(link.url);
      } else {
        return null;
      }

      return Feature.custom(
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

  /// returns a new instance with information which cannot be hardcoded (must be fetched from the server)
  Feature withServerData({required int id, required int index, required bool favorite}) {
    return Feature.custom(id: id, index: index, icon: icon, shortName: shortName, longName: longName, recommendedFavorite: favorite, onOpen: onOpen);
  }

  @override
  String toString() {
    return shortName;
  }

  /// opens the [OvguAccountScreen] instead if user has not setup an OVGU account
  /// after login, the actual screen will be open
  static Future<void> _pushScreenWithOvguAccount(BuildContext context, SimpleWidgetBuilder builder) {
    if (SettingsService.instance.hasOvguAccount())
      return pushScreen(context, builder);
    else
      return pushScreen(context, () => OvguAccountScreen(onLogin: () => pushScreen(context, builder)));
  }
}