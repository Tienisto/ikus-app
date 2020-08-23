import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/post.dart';

class PostGroup {

  final Channel channel;
  final List<Post> posts;

  PostGroup(this.channel, this.posts);
}