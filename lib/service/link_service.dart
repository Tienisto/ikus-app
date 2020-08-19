import 'package:ikus_app/model/link.dart';
import 'package:ikus_app/model/link_group.dart';

class LinkService {

  static List<LinkGroup> _links = [
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

  static List<LinkGroup> getLinks() {
    return _links;
  }
}