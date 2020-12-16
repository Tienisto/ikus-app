class PodcastFile {

  final String name;
  final String file;
  final String text; // nullable

  PodcastFile({this.name, this.file, this.text});

  static PodcastFile fromMap(Map<String, dynamic> map) {
    return PodcastFile(
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