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
  final double price;
  final List<FoodTag> tags;

  Food({this.name, this.price, this.tags});

  static Food fromMap(Map<String, dynamic> map) {
    List<FoodTag> tags = map['tags']
        .map((tag) => FoodTag.values.firstWhere((element) => describeEnum(element) == tag, orElse: () => null))
        .where((tag) => tag != null)
        .toList()
        .cast<FoodTag>();
    return Food(
        name: map['name'],
        price: tags.any((tag) => tag == FoodTag.SIDES) ? null : map['price'], // TODO: simplify when server responds with price = null
        tags: tags
    );
  }

  @override
  String toString() {
    return '$name ($price)';
  }
}

extension FoodMembers on FoodTag {
  String get name => {
    FoodTag.VEGAN: t.mensa.tags.vegan,
    FoodTag.VEGETARIAN: t.mensa.tags.vegetarian,
    FoodTag.GARLIC: t.mensa.tags.garlic,
    FoodTag.FISH: t.mensa.tags.fish,
    FoodTag.CHICKEN: t.mensa.tags.chicken,
    FoodTag.BEEF: t.mensa.tags.beef,
    FoodTag.PIG: t.mensa.tags.pig,
    FoodTag.SOUP: t.mensa.tags.soup,
    FoodTag.ALCOHOL: t.mensa.tags.alcohol,
    FoodTag.SIDES: t.mensa.tags.sides
  }[this];

  Color get color => {
    FoodTag.VEGAN: Colors.green,
    FoodTag.VEGETARIAN: Colors.green,
    FoodTag.GARLIC: Colors.purple,
    FoodTag.FISH: Colors.blue,
    FoodTag.CHICKEN: Colors.pink,
    FoodTag.BEEF: Colors.pink,
    FoodTag.PIG: Colors.pink,
    FoodTag.SOUP: Colors.lime,
    FoodTag.ALCOHOL: Colors.grey,
    FoodTag.SIDES: Colors.blueGrey
  }[this];
}