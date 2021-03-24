import 'package:ikus_app/service/app_config_service.dart';
import 'package:ikus_app/service/contact_service.dart';
import 'package:ikus_app/service/calendar_service.dart';
import 'package:ikus_app/service/faq_service.dart';
import 'package:ikus_app/service/handbook_service.dart';
import 'package:ikus_app/service/link_service.dart';
import 'package:ikus_app/service/mail_service.dart';
import 'package:ikus_app/service/mensa_service.dart';
import 'package:ikus_app/service/news_service.dart';
import 'package:ikus_app/service/audio_service.dart';
import 'package:ikus_app/utility/callbacks.dart';

abstract class SyncableService {

  /// service id used for equality check and debugging
  String get id;

  /// description, for display purposes, shown in sync screen
  String getDescription();

  /// update data from network or from local storage
  /// if [useNetwork] is true, then allow fetching data from the internet
  /// if [useJSON] is not null, then ALWAYS prefer this over network fetch
  /// if [showNotifications] is true, then allow the service to push notifications on specific events
  /// if [onBatchFinished] is not null, then move specific actions to this callback (e.g. show notifications at the end of batch update)
  Future<void> sync({
    required bool useNetwork,
    String? useJSON,
    bool showNotifications = false,
    AddFutureCallback? onBatchFinished
  });

  /// timestamp of last successful sync (from network or useJSON)
  /// may be null before first sync
  DateTime getLastUpdate();

  /// constant amount of time after which the service need to be synced
  /// happens during app start or background fetch
  Duration get maxAge;

  /// a constant for batch update
  String? get batchKey;

  /// list of all services extending SyncableService
  static List<SyncableService> get services => [
    NewsService.instance,
    CalendarService.instance,
    MensaService.instance,
    LinkService.instance,
    HandbookService.instance,
    AudioService.instance,
    FAQService.instance,
    ContactService.instance,
    MailService.instance,
    AppConfigService.instance
  ];

  /// same as [services] but without [AppConfigService]
  static List<SyncableService> get servicesWithoutAppConfig => [
    NewsService.instance,
    CalendarService.instance,
    MensaService.instance,
    LinkService.instance,
    HandbookService.instance,
    AudioService.instance,
    FAQService.instance,
    ContactService.instance,
    MailService.instance
  ];
}