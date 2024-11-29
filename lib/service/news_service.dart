import 'dart:convert';

import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/local/data_with_timestamp.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/post.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/channel_handler.dart';

class NewsService implements SyncableService {

  static final NewsService _instance = NewsService();
  static NewsService get instance => _instance;

  late DateTime _lastUpdate;
  late ChannelHandler<Post> _channelHandler;
  late List<Post> _posts;

  @override
  String id = 'NEWS';

  @override
  String getDescription() => t.sync.items.news;

  @override
  Future<void> sync({required bool useNetwork, String? useJSON, bool showNotifications = false, AddFutureCallback? onBatchFinished}) async {
    DataWithTimestamp data = await ApiService.getCacheOrFetchString(
      route: 'news',
      locale: LocaleSettings.currentLocale.languageTag,
      useJSON: useJSON,
      useNetwork: useNetwork,
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

    List<int>? subscribedIds = SettingsService.instance.getNewsChannels();
    List<Channel> subscribedChannels = subscribedIds != null ? channels.where((channel) => subscribedIds.any((id) => channel.id == id)).toList() : [...channels];

    _channelHandler = ChannelHandler(channels, subscribedChannels);
    _posts = posts;
    _lastUpdate = data.timestamp;
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  @override
  Duration maxAge = Duration(hours: 1);

  @override
  String batchKey = 'NEWS';

  List<Post> getPosts() {
    return _channelHandler.onlySubscribed(_posts, (item) => item.channel.id);
  }

  List<Channel> getChannels() {
    return _channelHandler.getAvailable();
  }

  List<Channel> getSubscribed() {
    return _channelHandler.getSubscribed();
  }

  void subscribe(Channel channel) {
    _channelHandler.subscribe(channel);
    _updateChannelSettings();
  }

  void unsubscribe(Channel channel) {
    _channelHandler.unsubscribe(channel);
    _updateChannelSettings();
  }

  void _updateChannelSettings() {
    List<int> subscribed = _channelHandler.getSubscribed().map((channel) => channel.id).toList();
    SettingsService.instance.setNewsChannels(subscribed);
  }
}