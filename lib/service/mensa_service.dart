import 'dart:convert';

import 'package:http/http.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/food.dart';
import 'package:ikus_app/model/menu.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';

class MensaService implements SyncableService {

  static final MensaService _instance = _init();
  static MensaService get instance => _instance;

  DateTime _lastUpdate;
  Map<MensaLocation, List<Menu>> _menu;

  static MensaService _init() {
    MensaService service = MensaService();

    service._menu = {
      MensaLocation.UNI_CAMPUS_DOWN: [
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
      ],
      MensaLocation.UNI_CAMPUS_UP: [
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
    };

    service._lastUpdate = DateTime(2020, 8, 24, 13, 12);
    return service;
  }

  @override
  String getName() => t.main.settings.syncItems.mensa;

  @override
  Future<void> sync() async {
    Response response = await ApiService.getCacheOrFetch('mensa', LocaleSettings.currentLocale);
    Map<String, dynamic> map = jsonDecode(response.body);
    List<MapEntry<MensaLocation, List<Menu>>> result = map.entries.map((entry) {
      List<dynamic> list = entry.value;
      List<Menu> menus = list.map((m) => Menu.fromMap(m)).toList().cast<Menu>();
      return MapEntry(entry.key.toMensaLocation(), menus);
    }).where((entry) => entry.key != null).toList();

    _menu = Map.fromEntries(result);
    _lastUpdate = DateTime.now();
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  Map<MensaLocation, List<Menu>> getMenu() {
    return _menu;
  }
}