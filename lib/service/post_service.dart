import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/post.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/utility/channel_handler.dart';

class PostService {

  static Channel _akaa = Channel(id: 1, name: "AKAA");
  static Channel _ikus = Channel(id: 2, name: "IKUS");
  static Channel _wohnheim = Channel(id: 3, name: "Wohnheim");
  static ChannelHandler<Post> _channelHandler = ChannelHandler([_akaa, _ikus, _wohnheim], [_akaa, _ikus, _wohnheim]);

  static String _loremIpsum = 'At <b>vero</b> eos et <span style="color: red">accusamus</span> et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.<br><br>Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae.<br><table><tr><th>Firstname</th><th>Lastname</th><th>Age</th></tr><tr><td>Jill</td><td>Smith</td><td>50</td></tr><tr><td>Eve</td><td>Jackson</td><td>94</td></tr></table><br>Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.';
  static Image _img0 = Image.asset('assets/img/logo-512-alpha.png', semanticLabel: "OVGU");
  static Image _img1 = Image.network('https://www.ovgu.de/unimagdeburg_media/Presse/Bilder/Pressemitteilungen/2020/Studieninteressierte+auf+dem+Campus+%28c%29+Stefan+Berger-height-600-p-85676-width-900.jpg', semanticLabel: "Studenten");
  static Image _img2 = Image.network('https://www.ovgu.de/unimagdeburg_media/Universit%C3%A4t/Was+uns+auszeichnet/2020_3/Dr_+Kristin+Hecht+im+Labor+%28c%29+Jana+Du%CC%88nnhaupt+Uni+Magdeburg-height-600-width-900-p-85822.jpg', semanticLabel: 'Labor');
  static List<Post> _posts = [
    Post(title: "Dr.-Ing Jens Strackeljan als Rektor gewählt", preview: "Prof. Dr.-Ing. Jens Strackeljan wurde als Rektor der Otto-von-Guericke-Universität Magdeburg im Amt wiedergewählt. Am 15. Juli 2020 hat der erweiterte Senat, das höchste Gremium der Universität,", content: _loremIpsum, channel: _ikus, date: DateTime(2020, 7, 15), images: []),
    Post(title: "Dr.-Ing Jens Strackeljan als Rektor gewählt", preview: "Prof. Dr.-Ing. Jens Strackeljan wurde als Rektor der Otto-von-Guericke-Universität Magdeburg im Amt wiedergewählt. Am 15. Juli 2020 hat der erweiterte Senat, das höchste Gremium der Universität,", content: _loremIpsum, channel: _wohnheim, date: DateTime(2020, 7, 15), images: [_img1, _img2]),
    Post(title: "Dr.-Ing Jens Strackeljan als Rektor gewählt", preview: "Prof. Dr.-Ing. Jens Strackeljan wurde als Rektor der Otto-von-Guericke-Universität Magdeburg im Amt wiedergewählt. Am 15. Juli 2020 hat der erweiterte Senat, das höchste Gremium der Universität,", content: _loremIpsum, channel: _akaa, date: DateTime(2020, 7, 15), images: [_img0]),
    Post(title: "Dr.-Ing Jens Strackeljan als Rektor gewählt", preview: "Prof. Dr.-Ing. Jens Strackeljan wurde als Rektor der Otto-von-Guericke-Universität Magdeburg im Amt wiedergewählt. Am 15. Juli 2020 hat der erweiterte Senat, das höchste Gremium der Universität,", content: _loremIpsum, channel: _wohnheim, date: DateTime(2020, 7, 15), images: [_img2, _img0])
  ];

  static Future<void> sync() async {
    Response response = await ApiService.getOrCached('public/news', LocaleSettings.currentLocale);
    Map<String, dynamic> map = jsonDecode(response.body);
    List<dynamic> channelsRaw = map['channels'];
    List<Channel> channels = channelsRaw.map((c) => Channel.fromMap(c)).toList();

    List<dynamic> postsRaw = map['posts'];
    List<Post> posts = postsRaw.map((p) => Post.fromMap(p)).toList();

    _channelHandler = ChannelHandler(channels, [...channels]);
    _posts = posts;
  }

  static List<Post> getPosts() {
    return _channelHandler.filter(_posts, (item) => item.channel.id);
  }

  static List<Channel> getChannels() {
    return _channelHandler.getAvailable();
  }

  static List<Channel> getSubscribed() {
    return _channelHandler.getSubscribed();
  }

  static Future<void> subscribe(Channel channel) async {
    await _channelHandler.subscribe(channel);
  }

  static Future<void> unsubscribe(Channel channel) async {
    await _channelHandler.unsubscribe(channel);
  }
}