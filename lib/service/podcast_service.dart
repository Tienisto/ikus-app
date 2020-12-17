import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/podcast.dart';
import 'package:ikus_app/model/podcast_file.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/callbacks.dart';

class PodcastService implements SyncableService {

  static final PodcastService _instance = PodcastService();
  static PodcastService get instance => _instance;

  DateTime _lastUpdate;

  @override
  String id = 'PODCASTS';

  @override
  String getDescription() => t.sync.items.podcasts;

  @override
  Future<void> sync({@required bool useNetwork, String useJSON, bool showNotifications = false, AddFutureCallback onBatchFinished}) async {
    _lastUpdate = ApiService.FALLBACK_TIME;
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  @override
  Duration maxAge = Duration(days: 1);

  @override
  String batchKey; // TODO

  Future<List<Podcast>> getPodcasts() async {
    return [
      Podcast(
        id: 1,
        name: 'Stadtführung',
        image: 'https://www.ovgu.de/unimagdeburg_media/International/International+Neu/Uniporta+der+OVGU+730+x+350-height-350-p-70456-width-730.jpg',
        files: [
          PodcastFile(
            name: '1. Katharinenturm',
            file: 'test',
            text: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer'
          ),
          PodcastFile(
            name: '2. Grüne Zitadelle',
            file: 'test',
          ),
          PodcastFile(
            name: '2. Grüne Zitadelle',
            file: 'test',
          ),
          PodcastFile(
            name: '2. Grüne Zitadelle',
            file: 'test',
          )
        ]
      ),
      Podcast(
        id: 2,
        name: 'Stadtführung',
        image: 'https://www.ovgu.de/unimagdeburg_media/International/International+Neu/Uniporta+der+OVGU+730+x+350-height-350-p-70456-width-730.jpg',
        files: [
          PodcastFile(
            name: '1. Katharinenturm',
            file: 'test',
            text: 'Blablabla'
          ),
          PodcastFile(
            name: '2. Grüne Zitadelle',
            file: 'test',
          )
        ]
      )
    ];
  }
}