import 'package:ikus_app/service/contact_service.dart';
import 'package:ikus_app/service/event_service.dart';
import 'package:ikus_app/service/faq_service.dart';
import 'package:ikus_app/service/handbook_service.dart';
import 'package:ikus_app/service/link_service.dart';
import 'package:ikus_app/service/mensa_service.dart';
import 'package:ikus_app/service/post_service.dart';

abstract class SyncableService {

  String getName();
  Future<void> sync({bool useCacheOnly});
  DateTime getLastUpdate();

  // list of all services extending SyncableService
  static List<SyncableService> get services => [
    PostService.instance,
    EventService.instance,
    MensaService.instance,
    LinkService.instance,
    HandbookService.instance,
    FAQService.instance,
    ContactService.instance
  ];
}