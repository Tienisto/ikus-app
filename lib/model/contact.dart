class Contact {

  final String name;
  final String image;
  final String email;
  final String phoneNumber;
  final String place;
  final String openingHours;

  Contact({this.name, this.image, this.email, this.phoneNumber, this.place, this.openingHours});

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
        name: map['name'],
        image: map['file'],
        email: map['email'],
        phoneNumber: map['phoneNumber'],
        place: map['place'],
        openingHours: map['openingHours']
    );
  }

  @override
  String toString() {
    return name;
  }
}