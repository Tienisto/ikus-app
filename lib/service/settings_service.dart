import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:ikus_app/model/feature.dart';
import 'package:ikus_app/model/mensa_info.dart';

class SettingsService {

  static final SettingsService _instance = SettingsService();
  static SettingsService get instance => _instance;

  String _locale;
  List<Feature> _favorites;
  List<int> _newsChannels;
  List<int> _calendarChannels;
  Mensa _mensa;
  bool _devServer;

  void init() {
    // it uses cache only anyways
    Box box = _box;
    _locale = box.get('locale');
    _favorites = box
        .get('favorite_features', defaultValue: [Feature.MAP, Feature.MENSA, Feature.LINKS].map((feature) => describeEnum(feature)))
        .map((key) => (key as String).toFeature())
        .where((feature) => feature != null)
        .toList()
        .cast<Feature>();
    _newsChannels = box
        .get('news_channels')
        ?.cast<int>();
    _calendarChannels = box
        .get('calendar_channels')
        ?.cast<int>();
    _devServer = box.get('dev_server', defaultValue: false);
    _mensa = (box.get('mensa') as String)?.toMensa() ?? Mensa.UNI_CAMPUS_DOWN;
  }

  Box get _box  => Hive.box('settings');

  void setLocale(String locale) {
    _box.put('locale', locale);
    _locale = locale;
  }

  String getLocale() {
    return _locale;
  }

  void setFavorites(List<Feature> favorites) {
    _box.put('favorite_features', favorites.map((feature) => describeEnum(feature)).toList());
    _favorites = favorites;
  }

  void toggleFavorite(Feature feature) {
    List<Feature> next;
    if (isFavorite(feature))
      next = _favorites.where((f) => f != feature).toList(); // remove
    else
      next = [ ..._favorites, feature ].toSet().toList()..sort((a, b) => a.index - b.index); // add
    setFavorites(next);
  }

  bool isFavorite(Feature feature) {
    return _favorites.indexOf(feature) != -1;
  }

  List<Feature> getFavorites() {
    return _favorites;
  }

  void setNewsChannels(List<int> channels) {
    _box.put('news_channels', channels);
    _newsChannels = channels;
  }

  List<int> getNewsChannels() {
    return _newsChannels;
  }

  void setCalendarChannels(List<int> channels) {
    _box.put('calendar_channels', channels);
    _calendarChannels = channels;
  }

  List<int> getCalendarChannels() {
    return _calendarChannels;
  }

  void setMensa(Mensa mensa) {
    _box.put('mensa', describeEnum(mensa));
    _mensa = mensa;
  }

  Mensa getMensa() {
    return _mensa;
  }

  void setDevServer(bool dev) {
    _box.put('dev_server', dev);
    _devServer = dev;
  }

  bool getDevServer() {
    return _devServer;
  }

  /// reinitialize with default values
  Future<void> clear() async {
    await _box.clear();
    init();
  }
}