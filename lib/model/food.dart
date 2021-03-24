import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';

enum FoodTag {
  VEGAN,
  VEGETARIAN,
  GARLIC, // Knoblauch
  FISH,
  CHICKEN,
  BEEF,
  PIG,
  SOUP,
  ALCOHOL,
  SIDES
}

class Food {
  final String name;
  final double? price;
  final List<FoodTag> tags;

  Food({required this.name, required this.price, required this.tags});

  static Food fromMap(Map<String, dynamic> map) {
    return Food(
        name: map['name'],
        price: map['price'],
        tags: map['tags']
            .map((tag) => FoodTag.values.firstWhereOrNull((element) => describeEnum(element) == tag))
            .where((tag) => tag != null)
            .toList()
            .cast<FoodTag>()
    );
  }

  @override
  String toString() {
    return '$name ($price)';
  }
}

extension FoodMembers on FoodTag {
  String get name {
    switch (this) {
      case FoodTag.VEGAN:
        return t.mensa.tags.vegan;
      case FoodTag.VEGETARIAN:
        return t.mensa.tags.vegetarian;
      case FoodTag.GARLIC:
        return t.mensa.tags.garlic;
      case FoodTag.FISH:
        return t.mensa.tags.fish;
      case FoodTag.CHICKEN:
        return t.mensa.tags.chicken;
      case FoodTag.BEEF:
        return t.mensa.tags.beef;
      case FoodTag.PIG:
        return t.mensa.tags.pig;
      case FoodTag.SOUP:
        return t.mensa.tags.soup;
      case FoodTag.ALCOHOL:
        return t.mensa.tags.alcohol;
      case FoodTag.SIDES:
        return t.mensa.tags.sides;
    }
  }

  Color get color {
    switch (this) {
      case FoodTag.VEGAN:
        return Colors.green;
      case FoodTag.VEGETARIAN:
        return Colors.green;
      case FoodTag.GARLIC:
        return Colors.purple;
      case FoodTag.FISH:
        return Colors.blue;
      case FoodTag.CHICKEN:
        return Colors.pink;
      case FoodTag.BEEF:
        return Colors.pink;
      case FoodTag.PIG:
        return Colors.pink;
      case FoodTag.SOUP:
        return Colors.lime;
      case FoodTag.ALCOHOL:
        return Colors.grey;
      case FoodTag.SIDES:
        return Colors.blueGrey;
    }
  }
}