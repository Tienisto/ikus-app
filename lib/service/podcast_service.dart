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
      ),
      Podcast(
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