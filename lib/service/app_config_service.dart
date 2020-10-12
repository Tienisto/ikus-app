import 'dart:convert';

import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/utility/extensions.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/api_data.dart';
import 'package:ikus_app/model/feature.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';

class AppConfigService implements SyncableService {

  static const int API_VERSION = 1;
  static final AppConfigService _instance = AppConfigService();
  static AppConfigService get instance => _instance;

  DateTime _lastUpdate;
  List<Feature> _features;
  List<Feature> _favoriteFeatures;
  List<Feature> _recommendedFavoriteFeatures;

  @override
  String getName() => t.main.settings.syncItems.appConfig;

  @override
  Future<void> sync({bool useCacheOnly}) async {
    ApiData data = await ApiService.getCacheOrFetchString(
      route: 'app-config',
      locale: LocaleSettings.currentLocale,
      useCacheOnly: useCacheOnly,
      fallback: { 'version': API_VERSION, 'features': [] }
    );

    Map<String, dynamic> map = jsonDecode(data.data);
    List<dynamic> featureList = map["features"];

    _features = featureList
        .mapIndexed((feature, index) => Feature.fromMap(index, feature))
        .where((feature) => feature != null)
        .toList();
    _recommendedFavoriteFeatures = _features.where((feature) => feature.recommendedFavorite).toList();

    List<int> favoriteIds = SettingsService.instance.getFavorites();
    _favoriteFeatures = _features.where((feature) => favoriteIds.any((id) => feature.id == id)).toList();
    if (_lastUpdate == ApiService.FALLBACK_TIME) {
      print(' -> first app config fetch ($_lastUpdate) -> use recommended favorites');
      useRecommendedFavorites();
    }

    _lastUpdate = data.timestamp;
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  @override
  Duration getMaxAge() => Duration(days: 1);

  List<Feature> getFeatures() {
    return _features;
  }

  List<Feature> getFavoriteFeatures() {
    return _favoriteFeatures;
  }

  void useRecommendedFavorites() {
    _favoriteFeatures = [..._recommendedFavoriteFeatures];
    List<int> favoriteIds = _favoriteFeatures.map((f) => f.id).toList();
    SettingsService.instance.setFavorites(favoriteIds);
  }

  void toggleFavorite(Feature feature) {
    List<Feature> next;
    if (isFavorite(feature))
      next = _favoriteFeatures.where((f) => f.id != feature.id).toList(); // remove
    else
      next = [ ..._favoriteFeatures, feature ].toSet().toList()..sort((a, b) => a.index - b.index); // add

    _favoriteFeatures = next;
    List<int> favoriteIds = next.map((f) => f.id).toList();
    SettingsService.instance.setFavorites(favoriteIds);
  }

  bool isFavorite(Feature feature) {
    return _favoriteFeatures.any((element) => element.id == feature.id);
  }
}