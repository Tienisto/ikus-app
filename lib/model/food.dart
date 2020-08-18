import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';

enum FoodTag {
  VEGAN,
  VEGETARIAN,
  GARLIC, // Knoblauch
  FISH,
  CHICKEN,
  BEEF,
  PIG
}

class Food {
  final String name;
  final double price;
  final List<FoodTag> tags;

  Food(this.name, this.price, this.tags);
}

extension FoodMembers on FoodTag {
  String get name => {
    FoodTag.VEGAN: t.mensa.tags.vegan,
    FoodTag.VEGETARIAN: t.mensa.tags.vegetarian,
    FoodTag.GARLIC: t.mensa.tags.garlic,
    FoodTag.FISH: t.mensa.tags.fish,
    FoodTag.CHICKEN: t.mensa.tags.chicken,
    FoodTag.BEEF: t.mensa.tags.beef,
    FoodTag.PIG: t.mensa.tags.pig
  }[this];

  Color get color => {
    FoodTag.VEGAN: Colors.green,
    FoodTag.VEGETARIAN: Colors.green,
    FoodTag.GARLIC: Colors.purple,
    FoodTag.FISH: Colors.blue,
    FoodTag.CHICKEN: Colors.pink,
    FoodTag.BEEF: Colors.pink,
    FoodTag.PIG: Colors.pink
  }[this];
}