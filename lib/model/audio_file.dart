class AudioFile {

  final String name;
  final String file;
  final String text; // nullable

  AudioFile({this.name, this.file, this.text});

  static AudioFile fromMap(Map<String, dynamic> map) {
    return AudioFile(
      name: map['name'],
      file: map['file'],
      text: map['text']
    );
  }

  @override
  String toString() {
    return name;
  }
}