class AudioFile {

  final int id; // for hero animation
  final String name;
  final String file;
  final String text; // nullable
  final String image; // nullable

  AudioFile({this.id, this.name, this.file, this.text, this.image});

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