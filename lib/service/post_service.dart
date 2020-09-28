import 'dart:convert';

import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/api_data.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/post.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/channel_handler.dart';

class PostService implements SyncableService {

  static final PostService _instance = PostService();
  static PostService get instance => _instance;

  DateTime _lastUpdate;
  ChannelHandler<Post> _channelHandler;
  List<Post> _posts;

  @override
  String getName() => t.main.settings.syncItems.news;

  @override
  Future<void> sync({bool useCache}) async {
    ApiData data = await ApiService.getCacheOrFetchString(
      route: 'news',
      locale: LocaleSettings.currentLocale,
      useCache: useCache,
      fallback: {
        'channels': [],
        'posts': []
      }
    );

    Map<String, dynamic> map = jsonDecode(data.data);
    List<dynamic> channelsRaw = map['channels'];
    List<Channel> channels = channelsRaw.map((c) => Channel.fromMap(c)).toList();

    List<dynamic> postsRaw = map['posts'];
    List<Post> posts = postsRaw.map((p) => Post.fromMap(p)).toList();

    _channelHandler = ChannelHandler(channels, [...channels]);
    _posts = posts;
    _lastUpdate = data.timestamp;
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  List<Post> getPosts() {
    return _channelHandler.filter(_posts, (item) => item.channel.id);
  }

  List<Channel> getChannels() {
    return _channelHandler.getAvailable();
  }

  List<Channel> getSubscribed() {
    return _channelHandler.getSubscribed();
  }

  Future<void> subscribe(Channel channel) async {
    await _channelHandler.subscribe(channel);
  }

  Future<void> unsubscribe(Channel channel) async {
    await _channelHandler.unsubscribe(channel);
  }
}