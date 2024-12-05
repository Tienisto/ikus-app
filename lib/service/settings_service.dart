import 'package:ikus_app/model/local/ovgu_account.dart';
import 'package:ikus_app/model/local/settings_data.dart';
import 'package:ikus_app/model/mensa_info.dart';
import 'package:ikus_app/service/persistent_service.dart';

class SettingsService {

  static final SettingsService _instance = SettingsService();
  static SettingsService get instance => _instance;

  late SettingsData _settings;
  OvguAccount? _ovguAccount;

  /// load all settings data from local storage
  Future<void> loadFromStorage() async {
    _settings = PersistentService.instance.getSettings(); // read from hive storage
    _ovguAccount = await PersistentService.instance.getOvguAccount(); // read from secure storage
  }

  /// saves the new settings config into hive
  /// does not include ovgu account
  Future<void> _persistSettings() async {
    await PersistentService.instance.setSettings(_settings);
  }

  void setWelcome(bool welcome) {
    _settings.welcome = welcome;
    _persistSettings();
  }

  bool getWelcome() {
    return _settings.welcome;
  }

  void setLocale(String locale) {
    _settings.locale = locale;
    _persistSettings();
  }

  String? getLocale() {
    return _settings.locale;
  }

  void setFavorites(List<int> favorites) {
    _settings.favorites = favorites;
    _persistSettings();
  }

  List<int> getFavorites() {
    return _settings.favorites;
  }

  void setNewsChannels(List<int> channels) {
    _settings.newsChannels = channels;
    _persistSettings();
  }

  List<int>? getNewsChannels() {
    return _settings.newsChannels;
  }

  void setCalendarChannels(List<int> channels) {
    _settings.calendarChannels = channels;
    _persistSettings();
  }

  List<int>? getCalendarChannels() {
    return _settings.calendarChannels;
  }

  void setMyEvents(List<int> events) {
    _settings.myEvents = events;
    _persistSettings();
  }

  List<int> getMyEvents() {
    return _settings.myEvents;
  }

  void setMyEventsNotified2h(List<int> events) {
    _settings.myEventsNotified2h = events;
    _persistSettings();
  }

  List<int> getMyEventsNotified2h() {
    return _settings.myEventsNotified2h;
  }

  void setMensa(Mensa mensa) {
    _settings.mensa = mensa;
    _persistSettings();
  }

  Mensa getMensa() {
    return _settings.mensa;
  }

  void setDevSettings(bool dev) {
    _settings.devSettings = dev;
    _persistSettings();
  }

  bool getDevSettings() {
    return _settings.devSettings;
  }

  void setDevServer(bool dev) {
    _settings.devServer = dev;
    _persistSettings();
  }

  bool getDevServer() {
    return _settings.devServer;
  }

  Future<void> setOvguAccount({required String name, required String password, String? mailAddress}) async {
    OvguAccount account = OvguAccount(name: name, password: password, mailAddress: mailAddress);
    PersistentService.instance.setOvguAccount(account);
    _ovguAccount = account;
  }

  Future<void> deleteOvguAccount() async {
    PersistentService.instance.deleteOvguAccount();
    _ovguAccount = null;
  }

  bool hasOvguAccount() {
    return _ovguAccount != null;
  }

  OvguAccount? getOvguAccount() {
    return _ovguAccount;
  }
}