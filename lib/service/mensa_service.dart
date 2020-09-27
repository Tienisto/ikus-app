import 'dart:convert';

import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/api_data.dart';
import 'package:ikus_app/model/food.dart';
import 'package:ikus_app/model/mensa_info.dart';
import 'package:ikus_app/model/menu.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';

class MensaService implements SyncableService {

  static final MensaService _instance = _init();
  static MensaService get instance => _instance;

  DateTime _lastUpdate;
  List<MensaInfo> _menu;

  static MensaService _init() {
    MensaService service = MensaService();

    service._menu = [
      MensaInfo(
        name: Mensa.UNI_CAMPUS_DOWN,
        menus: [
          Menu(
              date: DateTime.now(),
              food: [
                Food(name: 'Magde-Burger mit panierter Jagdwurstscheibe, Letscho, Weißkraut und Röstzwiebeln dazu Kartoffelspalten und Kräuterquark', price: 2.8, tags: [FoodTag.PIG]),
                Food(name: 'Paniertes Rotbarschfilet mit Remouladensoße dazu eine Gemüsebeilage und eine Sättigungsbeilage zur Auswahl', price: 2.6, tags: [FoodTag.FISH]),
                Food(name: '2 Sesam-Karotten-Knuspersticks mit Limetten-Ingwersoße dazu eine Gemüsebeilage und eine Sättigungsbeilage zur Auswahl', price: 2.6, tags: [FoodTag.VEGAN])
              ]
          ),
          Menu(
              date: DateTime.now().add(Duration(days: 1)),
              food: [
                Food(name: 'Magde-Burger mit panierter Jagdwurstscheibe, Letscho, Weißkraut und Röstzwiebeln dazu Kartoffelspalten und Kräuterquark', price: 2.8, tags: [FoodTag.SOUP]),
                Food(name: 'Paniertes Rotbarschfilet mit Remouladensoße dazu eine Gemüsebeilage und eine Sättigungsbeilage zur Auswahl', price: 2.6, tags: [FoodTag.ALCOHOL]),
                Food(name: '2 Sesam-Karotten-Knuspersticks mit Limetten-Ingwersoße dazu eine Gemüsebeilage und eine Sättigungsbeilage zur Auswahl', price: 2.6, tags: [FoodTag.VEGAN])
              ]
          )
        ]
      ),
      MensaInfo(
        name: Mensa.UNI_CAMPUS_UP,
        menus: [
          Menu(
              date: DateTime(2020,8,12),
              food: [
                Food(name: 'Feuriges Gemüse-Rindfleisch-Curry mit Mienudeln ', price: 2.3, tags: [FoodTag.BEEF, FoodTag.GARLIC]),
                Food(name: 'Schweinesteak Förster Art mit Waldpilzsoße dazu eine Gemüsebeilage und eine Sättigungsbeilage zur Auswahl', price: 2.6, tags: [FoodTag.PIG]),
                Food(name: '5 Kartoffelrösti mit Kräuterquark und Gurkensalat', price: 1.5, tags: [FoodTag.VEGETARIAN]),
                Food(name: 'Feuriges Gemüse-Rindfleisch-Curry mit Mienudeln ', price: 2.3, tags: [FoodTag.BEEF, FoodTag.GARLIC]),
                Food(name: 'Schweinesteak Förster Art mit Waldpilzsoße dazu eine Gemüsebeilage und eine Sättigungsbeilage zur Auswahl', price: 2.6, tags: [FoodTag.PIG]),
                Food(name: '5 Kartoffelrösti mit Kräuterquark und Gurkensalat', price: 1.5, tags: [FoodTag.VEGETARIAN])
              ]
          )
        ]
      )
    ];

    service._lastUpdate = DateTime(2020, 8, 24, 13, 12);
    return service;
  }

  @override
  String getName() => t.main.settings.syncItems.mensa;

  @override
  Future<void> sync() async {
    ApiData data = await ApiService.getCacheOrFetchString(
      route: 'mensa',
      locale: LocaleSettings.currentLocale,
      fallback: []
    );

    List<dynamic> list = jsonDecode(data.data);
    _menu = list.map((mensa) => MensaInfo.fromMap(mensa))
        .where((mensa) => mensa.name != null)
        .toList();

    if (!data.cached)
      _lastUpdate = DateTime.now();
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  List<MensaInfo> getMenu() {
    return _menu;
  }
}