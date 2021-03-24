import 'package:ikus_app/model/channel.dart';
import 'package:intl/intl.dart';

class Post {

  static DateFormat _dateFormatter = DateFormat("dd.MM.yyyy");

  final int id;
  final String title;
  final String preview;
  final String content;
  final Channel channel;
  final DateTime date;
  final List<String> images;
  final bool pinned;

  const Post({required this.id, required this.title, required this.preview, required this.content, required this.channel, required this.date, required this.images, required this.pinned});

  String get formattedDate {
    return _dateFormatter.format(date);
  }

  static Post fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      channel: Channel.fromMap(map['channel']),
      date: DateTime.parse(map['date']),
      title: map['title'],
      preview: map['preview'],
      content: map['content'],
      images: map['files'].map((file) => file['fileName']).toList().cast<String>(),
      pinned: map['pinned'] ?? false
    );
  }

  @override
  String toString() {
    return '$title ($id)';
  }
}