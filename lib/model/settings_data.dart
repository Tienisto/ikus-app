import 'package:ikus_app/model/mensa_info.dart';

class SettingsData {

  bool welcome;
  String locale; // nullable
  List<int> favorites;
  List<int> newsChannels; // nullable
  List<int> calendarChannels; // nullable
  List<int> myEvents;
  Mensa mensa;
  bool devServer;

  SettingsData({
    this.welcome,
    this.locale,
    this.favorites,
    this.newsChannels,
    this.calendarChannels,
    this.myEvents,
    this.mensa,
    this.devServer
  });
}