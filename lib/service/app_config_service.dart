import 'dart:convert';
import 'dart:developer';

import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/extensions.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/local/data_with_timestamp.dart';
import 'package:ikus_app/model/feature.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';

class AppConfigService implements SyncableService {

  static const int API_VERSION = 1;
  static const String LOG_NAME = 'AppConfig';
  static final AppConfigService _instance = AppConfigService();
  static AppConfigService get instance => _instance;

  DateTime _lastUpdate = ApiService.FALLBACK_TIME;
  late bool _compatibleWithApi;
  late List<Feature> _features;
  late List<Feature> _favoriteFeatures;
  late List<Feature> _recommendedFavoriteFeatures;

  @override
  String id = 'APP_CONFIG';

  @override
  String getDescription() => t.sync.items.appConfig;

  @override
  Future<void> sync({required bool useNetwork, String? useJSON, bool showNotifications = false, AddFutureCallback? onBatchFinished}) async {
    assert(useJSON == null, 'no batch update');

    DataWithTimestamp data = await ApiService.getCacheOrFetchString(
      route: 'app-config',
      locale: LocaleSettings.currentLocale.languageTag,
      useJSON: useJSON,
      useNetwork: useNetwork,
      fallback: { 'version': API_VERSION, 'features': [] }
    );

    Map<String, dynamic> map = jsonDecode(data.data);
    int apiLevel = map["version"];

    if (API_VERSION < apiLevel) {
      _compatibleWithApi = false;
      log(' -> App is not compatible with API ($API_VERSION < $apiLevel)', name: LOG_NAME);
    } else if (useNetwork) {
      _compatibleWithApi = true;
      log(' -> API level OK ($API_VERSION >= $apiLevel)', name: LOG_NAME);
    }

    List<dynamic> featureList = map["features"];

    _features = featureList
        .mapIndexed((feature, index) => Feature.fromMap(index, feature))
        .where((feature) => feature != null)
        .cast<Feature>()
        .toList();

    _recommendedFavoriteFeatures = _features.where((feature) => feature.recommendedFavorite).toList();

    List<int> favoriteIds = SettingsService.instance.getFavorites();
    _favoriteFeatures = _features.where((feature) => favoriteIds.any((id) => feature.id == id)).toList();
    if (_lastUpdate == ApiService.FALLBACK_TIME) {
      log(' -> first app config fetch ($_lastUpdate) -> use recommended favorites', name: LOG_NAME);
      useRecommendedFavorites();
    }

    _lastUpdate = data.timestamp;
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  @override
  Duration maxAge = Duration(days: 1);

  @override
  String batchKey = 'APP_CONFIG';

  bool isCompatibleWithApi() {
    return _compatibleWithApi;
  }

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