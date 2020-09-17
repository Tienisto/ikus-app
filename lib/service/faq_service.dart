import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/post.dart';
import 'package:ikus_app/model/post_group.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';

class FAQService implements SyncableService {

  static final FAQService _instance = _init();
  static FAQService get instance => _instance;

  DateTime _lastUpdate;
  List<PostGroup> _groups;

  static FAQService _init() {
    FAQService service = FAQService();

    String _loremIpsum = 'At <b>vero</b> eos et <span style="color: red">accusamus</span> et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.<br><br>Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae.<br><table><tr><th>Firstname</th><th>Lastname</th><th>Age</th></tr><tr><td>Jill</td><td>Smith</td><td>50</td></tr><tr><td>Eve</td><td>Jackson</td><td>94</td></tr></table><br>Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.';
    Image _img0 = Image.asset('assets/img/logo-512-alpha.png', semanticLabel: "OVGU");
    Image _img1 = Image.network('https://www.ovgu.de/unimagdeburg_media/Presse/Bilder/Pressemitteilungen/2020/Studieninteressierte+auf+dem+Campus+%28c%29+Stefan+Berger-height-600-p-85676-width-900.jpg', semanticLabel: "Studenten");
    Image _img2 = Image.network('https://www.ovgu.de/unimagdeburg_media/Universit%C3%A4t/Was+uns+auszeichnet/2020_3/Dr_+Kristin+Hecht+im+Labor+%28c%29+Jana+Du%CC%88nnhaupt+Uni+Magdeburg-height-600-width-900-p-85822.jpg', semanticLabel: 'Labor');

    Channel _allgemeines = Channel(id: 1, name: "Allgemeines");
    Channel _prufung = Channel(id: 2, name: "Prüfung");
    Channel _finanzierung = Channel(id: 3, name: "Finanzierung");
    List<Post> _posts = [
      Post(title: "Bis wann kann ich mich immatrikulieren?", preview: "Prof. Dr.-Ing. Jens Strackeljan wurde als Rektor der Otto-von-Guericke-Universität Magdeburg im Amt wiedergewählt. Am 15. Juli 2020 hat der erweiterte Senat, das höchste Gremium der Universität,", content: _loremIpsum, channel: _allgemeines, date: DateTime(2020, 7, 15), images: []),
      Post(title: "Wie aktiviere ich meine Studentenkarte?", preview: "Prof. Dr.-Ing. Jens Strackeljan wurde als Rektor der Otto-von-Guericke-Universität Magdeburg im Amt wiedergewählt. Am 15. Juli 2020 hat der erweiterte Senat, das höchste Gremium der Universität,", content: _loremIpsum, channel: _allgemeines, date: DateTime(2020, 7, 15), images: [_img1, _img2]),
      Post(title: "Wie lade ich Geld auf meine Studentenkarte auf?", preview: "Prof. Dr.-Ing. Jens Strackeljan wurde als Rektor der Otto-von-Guericke-Universität Magdeburg im Amt wiedergewählt. Am 15. Juli 2020 hat der erweiterte Senat, das höchste Gremium der Universität,", content: _loremIpsum, channel: _allgemeines, date: DateTime(2020, 7, 15), images: [_img0]),
      Post(title: "Wo kann ich ausdrucken?", preview: "Prof. Dr.-Ing. Jens Strackeljan wurde als Rektor der Otto-von-Guericke-Universität Magdeburg im Amt wiedergewählt. Am 15. Juli 2020 hat der erweiterte Senat, das höchste Gremium der Universität,", content: _loremIpsum, channel: _allgemeines, date: DateTime(2020, 7, 15), images: [_img2, _img0])
    ];

    service._groups = [
      PostGroup(channel: _allgemeines, posts: _posts),
      PostGroup(channel: _prufung, posts: _posts),
      PostGroup(channel: _finanzierung, posts: _posts)
    ];

    service._lastUpdate = DateTime(2020, 8, 24, 13, 12);
    return service;
  }

  @override
  String getName() => t.main.settings.syncItems.faq;

  @override
  Future<void> sync() async {
    Response response = await ApiService.getCacheOrFetch('faq', LocaleSettings.currentLocale);
    List<dynamic> groups = jsonDecode(response.body);
    _groups = groups.map((g) => PostGroup.fromMap(g)).toList().cast<PostGroup>();
    _lastUpdate = DateTime.now();
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  List<PostGroup> getFAQ() {
    return _groups;
  }
}