import 'package:flutter/material.dart';
import 'package:ikus_app/model/mensa_info.dart';

class SettingsData {

  bool welcome;
  String locale; // nullable
  List<int> favorites;
  List<int> newsChannels; // nullable
  List<int> calendarChannels; // nullable
  List<int> myEvents;
  Mensa mensa; // last opened mensa
  bool devSettings;
  bool devServer;

  SettingsData({
    @required this.welcome,
    @required this.locale,
    @required this.favorites,
    @required this.newsChannels,
    @required this.calendarChannels,
    @required this.myEvents,
    @required this.mensa,
    @required this.devSettings,
    @required this.devServer
  });
}