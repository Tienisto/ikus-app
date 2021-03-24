import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/post.dart';

class PostGroup {

  final Channel channel;
  final List<Post> posts;

  const PostGroup({required this.channel, required this.posts});

  static PostGroup fromMap(Map<String, dynamic> map) {
    return PostGroup(
        channel: Channel.fromMap(map['channel']),
        posts: map['posts'].map((post) => Post.fromMap(post)).toList().cast<Post>()
    );
  }

  @override
  String toString() {
    return '$channel [$posts]';
  }
}