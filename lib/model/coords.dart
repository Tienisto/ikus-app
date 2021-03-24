class Coords {

  final double x;
  final double y;

  Coords({required this.x, required this.y});

  static Coords fromMap(Map<String, dynamic> map) {
    return Coords(
        x: map['x'],
        y: map['y']
    );
  }

  @override
  String toString() {
    return '($x;$y)';
  }
}