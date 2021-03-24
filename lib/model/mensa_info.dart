import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/coords.dart';
import 'package:ikus_app/model/menu.dart';

enum Mensa {
  UNI_CAMPUS_DOWN,
  UNI_CAMPUS_UP,
  ZSCHOKKE,
  HERRENKRUG
}

class MensaInfo {
  final Mensa name;
  final String? openingHours;
  final Coords? coords;
  final List<Menu> menus;

  MensaInfo({required this.name, required this.openingHours, required this.coords, required this.menus});

  static MensaInfo fromMap(Map<String, dynamic> map) {
    return MensaInfo(
        name: (map['name'] as String).toMensa() ?? Mensa.UNI_CAMPUS_DOWN,
        openingHours: map['openingHours'],
        coords: map['coords'] != null ? Coords.fromMap(map['coords']) : null,
        menus: map['menus']
            .map((menu) => Menu.fromMap(menu))
            .toList()
            .cast<Menu>()
    );
  }

  @override
  String toString() {
    return '$name [$menus]';
  }
}

extension MensaLocationMembers on Mensa {
  String get name {
    switch (this) {
      case Mensa.UNI_CAMPUS_DOWN:
        return t.mensa.locations.uniCampusDown;
      case Mensa.UNI_CAMPUS_UP:
        return t.mensa.locations.uniCampusUp;
      case Mensa.ZSCHOKKE:
        return t.mensa.locations.zschokke;
      case Mensa.HERRENKRUG:
        return t.mensa.locations.herrenkrug;
    }
  }
}

extension MensaLocationParser on String {
  Mensa? toMensa() {
    return Mensa.values.firstWhereOrNull((element) => describeEnum(element) == this);
  }
}