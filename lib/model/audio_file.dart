class AudioFile {

  final int id; // for hero animation
  final String name;
  final String file;
  final String? text;
  final String? image;

  AudioFile({required this.id, required this.name, required this.file, required this.text, required this.image});

  static AudioFile fromMap(Map<String, dynamic> map) {
    return AudioFile(
      id: map['id'],
      name: map['name'],
      file: map['file'],
      text: map['text'],
      image: map['image']
    );
  }

  @override
  String toString() {
    return name;
  }
}