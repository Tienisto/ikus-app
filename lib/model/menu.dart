import 'package:ikus_app/model/food.dart';

class Menu {
  final DateTime date;
  final List<Food> food;

  Menu({required this.date, required this.food});

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