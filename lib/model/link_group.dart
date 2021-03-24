import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/link.dart';

class LinkGroup {

  final Channel channel;
  final List<Link> links;

  LinkGroup({required this.channel, required this.links});

  static LinkGroup fromMap(Map<String, dynamic> map) {
    return LinkGroup(
      channel: Channel.fromMap(map['channel']),
      links: map['links'].map((link) => Link.fromMap(link)).toList().cast<Link>(),
    );
  }

  @override
  String toString() {
    return channel.toString();
  }
}