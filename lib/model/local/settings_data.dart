import 'package:ikus_app/model/mensa_info.dart';

class SettingsData {

  bool welcome;
  String? locale;
  List<int> favorites;
  List<int>? newsChannels;
  List<int>? calendarChannels;
  List<int> myEvents;
  List<int> myEventsNotified2h;
  Mensa mensa; // last opened mensa
  bool devSettings;
  bool devServer;

  SettingsData({
    required this.welcome,
    required this.locale,
    required this.favorites,
    required this.newsChannels,
    required this.calendarChannels,
    required this.myEvents,
    required this.myEventsNotified2h,
    required this.mensa,
    required this.devSettings,
    required this.devServer
  });
}