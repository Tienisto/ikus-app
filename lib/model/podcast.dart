import 'package:ikus_app/model/podcast_file.dart';

class Podcast {

  final int id; // for hero animation
  final String name;
  final String image;
  final List<PodcastFile> files;

  Podcast({this.id, this.name, this.image, this.files});

  static Podcast fromMap(Map<String, dynamic> map) {
    return Podcast(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      files: map['files']
        .map((file) => PodcastFile.fromMap(file))
        .toList()
        .cast<PodcastFile>()
    );
  }

  @override
  String toString() {
    return name;
  }
}