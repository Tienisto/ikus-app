import 'package:flutter/material.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/post.dart';
import 'package:ikus_app/model/post_group.dart';

class FAQService {

  static String _loremIpsum = 'At <b>vero</b> eos et <span style="color: red">accusamus</span> et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.<br><br>Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae.<br><table><tr><th>Firstname</th><th>Lastname</th><th>Age</th></tr><tr><td>Jill</td><td>Smith</td><td>50</td></tr><tr><td>Eve</td><td>Jackson</td><td>94</td></tr></table><br>Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.';
  static Image _img0 = Image.asset('assets/img/logo-512-alpha.png', semanticLabel: "OVGU");
  static Image _img1 = Image.network('https://www.ovgu.de/unimagdeburg_media/Presse/Bilder/Pressemitteilungen/2020/Studieninteressierte+auf+dem+Campus+%28c%29+Stefan+Berger-height-600-p-85676-width-900.jpg', semanticLabel: "Studenten");
  static Image _img2 = Image.network('https://www.ovgu.de/unimagdeburg_media/Universit%C3%A4t/Was+uns+auszeichnet/2020_3/Dr_+Kristin+Hecht+im+Labor+%28c%29+Jana+Du%CC%88nnhaupt+Uni+Magdeburg-height-600-width-900-p-85822.jpg', semanticLabel: 'Labor');

  static Channel _allgemeines = Channel(1, "Allgemeines");
  static Channel _prufung = Channel(2, "Prüfung");
  static Channel _finanzierung = Channel(3, "Finanzierung");
  static List<Post> _posts = [
    Post("Bis wann kann ich mich immatrikulieren?", "Prof. Dr.-Ing. Jens Strackeljan wurde als Rektor der Otto-von-Guericke-Universität Magdeburg im Amt wiedergewählt. Am 15. Juli 2020 hat der erweiterte Senat, das höchste Gremium der Universität,", _loremIpsum, _allgemeines, DateTime(2020, 7, 15), []),
    Post("Wie aktiviere ich meine Studentenkarte?", "Prof. Dr.-Ing. Jens Strackeljan wurde als Rektor der Otto-von-Guericke-Universität Magdeburg im Amt wiedergewählt. Am 15. Juli 2020 hat der erweiterte Senat, das höchste Gremium der Universität,", _loremIpsum, _allgemeines, DateTime(2020, 7, 15), [_img1, _img2]),
    Post("Wie lade ich Geld auf meine Studentenkarte auf?", "Prof. Dr.-Ing. Jens Strackeljan wurde als Rektor der Otto-von-Guericke-Universität Magdeburg im Amt wiedergewählt. Am 15. Juli 2020 hat der erweiterte Senat, das höchste Gremium der Universität,", _loremIpsum, _allgemeines, DateTime(2020, 7, 15), [_img0]),
    Post("Wo kann ich ausdrucken?", "Prof. Dr.-Ing. Jens Strackeljan wurde als Rektor der Otto-von-Guericke-Universität Magdeburg im Amt wiedergewählt. Am 15. Juli 2020 hat der erweiterte Senat, das höchste Gremium der Universität,", _loremIpsum, _allgemeines, DateTime(2020, 7, 15), [_img2, _img0])
  ];

  static List<PostGroup> _groups = [
    PostGroup(_allgemeines, _posts),
    PostGroup(_prufung, _posts),
    PostGroup(_finanzierung, _posts)
  ];

  static List<PostGroup> getFAQ() {
    return _groups;
  }
}