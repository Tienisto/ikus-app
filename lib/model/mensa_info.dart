import 'package:collection/collection.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/coords.dart';
import 'package:ikus_app/model/menu.dart';

enum Mensa {
  UNI_CAMPUS_DOWN,
  UNI_CAMPUS_UP,
  ZSCHOKKE,
  HERRENKRUG,
  PIER_16
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
  String get label {
    switch (this) {
      case Mensa.UNI_CAMPUS_DOWN:
        return t.mensa.locations.uniCampusDown;
      case Mensa.UNI_CAMPUS_UP:
        return t.mensa.locations.uniCampusUp;
      case Mensa.ZSCHOKKE:
        return t.mensa.locations.zschokke;
      case Mensa.HERRENKRUG:
        return t.mensa.locations.herrenkrug;
      case Mensa.PIER_16:
        return t.mensa.locations.pier16;
    }
  }
}

extension MensaLocationParser on String {
  Mensa? toMensa() {
    return Mensa.values.firstWhereOrNull((element) => this == element.name);
  }
}