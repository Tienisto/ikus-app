import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/food.dart';

enum MensaLocation {
  UNI_CAMPUS_DOWN,
  UNI_CAMPUS_UP,
  ZSCHOKKE,
  HERRENKRUG
}

class Menu {
  final MensaLocation location;
  final DateTime date;
  final List<Food> food;

  Menu(this.location, this.date, this.food);
}

extension MensaLocationMembers on MensaLocation {
  String get name => {
    MensaLocation.UNI_CAMPUS_DOWN: t.mensa.locations.uniCampusDown,
    MensaLocation.UNI_CAMPUS_UP: t.mensa.locations.uniCampusUp,
    MensaLocation.ZSCHOKKE: t.mensa.locations.zschokke,
    MensaLocation.HERRENKRUG: t.mensa.locations.herrenkrug
  }[this];
}