import 'package:flutter/foundation.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/food.dart';

enum MensaLocation {
  UNI_CAMPUS_DOWN,
  UNI_CAMPUS_UP,
  ZSCHOKKE,
  HERRENKRUG
}

class Menu {
  final DateTime date;
  final List<Food> food;

  Menu({this.date, this.food});

  static Menu fromMap(Map<String, dynamic> map) {
    return Menu(
        date: DateTime.parse(map['date']).toLocal(),
        food: map['food']
            .map((food) => Food.fromMap(food))
            .toList()
            .cast<Food>()
    );
  }

  @override
  String toString() {
    return '$date [$food]';
  }
}

extension MensaLocationMembers on MensaLocation {
  String get name => {
    MensaLocation.UNI_CAMPUS_DOWN: t.mensa.locations.uniCampusDown,
    MensaLocation.UNI_CAMPUS_UP: t.mensa.locations.uniCampusUp,
    MensaLocation.ZSCHOKKE: t.mensa.locations.zschokke,
    MensaLocation.HERRENKRUG: t.mensa.locations.herrenkrug
  }[this];
}

extension MensaLocationParser on String {
  MensaLocation toMensaLocation() {
    return MensaLocation.values.firstWhere((element) => describeEnum(element) == this, orElse: () => null);
  }
}