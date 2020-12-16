import 'package:ikus_app/model/podcast_file.dart';

class Podcast {

  final String name;
  final String image;
  final List<PodcastFile> files;

  Podcast({this.name, this.image, this.files});

  static Podcast fromMap(Map<String, dynamic> map) {
    return Podcast(
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