import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/link.dart';
import 'package:ikus_app/model/link_group.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/globals.dart';

class LinkService implements SyncableService {

  static final LinkService _instance = _init();
  static LinkService get instance => _instance;

  DateTime _lastUpdate;
  List<LinkGroup> _links;

  static LinkService _init() {
    LinkService service = LinkService();

    service._links = [
      LinkGroup("Studieren", [
        Link("https://www.ovgu.de", "Die Uni-Homepage"),
        Link("https://lsf.ovgu.de", "Studentenportal"),
        Link("https://myovgu.ovgu.de", "MyOvgu Portal"),
        Link("https://webmailer.ovgu.de", "E-Mail Postfach"),
        Link("https://elearning.ovgu.de", "Das Moodle-Portal"),
        Link("https://www.studentenwerk-magdeburg.de", "Studentenwerk"),
        Link("http://www.servicecenter.ovgu.de/", "Campus Service Center")
      ]),
      LinkGroup("Leben", [
        Link("https://bahn.de", "Deutsche Bahn"),
        Link("https://www.unifilm.de/studentenkinos/MD_HiD", "Hörsaal im Dunkeln (HiD)")
      ]),
      LinkGroup("Arbeit", [
        Link("https://ovgu.jobteaser.com", "JobTeaser")
      ])
    ];

    service._lastUpdate = DateTime(2020, 8, 24, 13, 12);
    return service;
  }

  @override
  String getName() => t.main.settings.syncItems.links;

  @override
  Future<void> sync() async {
    await sleep(500);
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  List<LinkGroup> getLinks() {
    return _links;
  }
}