import 'package:ikus_app/model/audio_file.dart';

class Audio {

  final int id; // for hero animation
  final String name;
  final String? image;
  final List<AudioFile> files;

  Audio({required this.id, required this.name, required this.image, required this.files});

  static Audio fromMap(Map<String, dynamic> map) {
    return Audio(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      files: map['files']
        .map((file) => AudioFile.fromMap(file))
        .toList()
        .cast<AudioFile>()
    );
  }

  @override
  String toString() {
    return name;
  }
}