class Channel {

  final int id;
  final String name;

  Channel({required this.id, required this.name});

  static Channel fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'],
      name: map['name']
    );
  }

  @override
  String toString() {
    return '$name ($id)';
  }
}