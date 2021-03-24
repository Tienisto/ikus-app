class Contact {

  final String name;
  final String? image;
  final String? email;
  final String? phoneNumber;
  final String? place;
  final String? openingHours;
  final List<String> links;

  Contact({required this.name, required this.image, required this.email, required this.phoneNumber, required this.place, required this.openingHours, required this.links});

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'],
      image: map['file'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      place: map['place'],
      openingHours: map['openingHours'],
      links: map['links']?.cast<String>() ?? []
    );
  }

  @override
  String toString() {
    return name;
  }
}