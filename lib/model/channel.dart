class Channel {

  final int id;
  final String name;

  Channel({this.id, this.name});

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