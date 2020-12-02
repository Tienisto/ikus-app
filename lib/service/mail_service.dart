import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/data_with_timestamp.dart';
import 'package:ikus_app/model/mail_message.dart';
import 'package:ikus_app/model/mail_message_send.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/persistent_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/mail_facade.dart';

class MailService implements SyncableService {

  static final MailService _instance = MailService();
  static MailService get instance => _instance;

  MailFacade _mailFacade;
  DateTime _lastUpdate;
  Map<int, MailMessage> _mails;

  @override
  String getName() => t.sync.items.emails;

  @override
  Future<void> sync({bool useCacheOnly}) async {

    print(' -> Syncing Mails...');

    if (_mailFacade == null) {
      // create mail connection
      final account = SettingsService.instance.getOvguAccount();
      if (account == null) {
        _mails = {};
        _lastUpdate = ApiService.FALLBACK_TIME;
        return;
      }

      _mailFacade = await MailFacade.connect(name: account.name, password: account.password);

      if (_mailFacade == null) {
        _mails = {};
        _lastUpdate = ApiService.FALLBACK_TIME;
        return;
      }
    }

    // load from storage
    final data = PersistentService.instance.getMails();
    if (data != null) {
      _mails = data.data;
      _lastUpdate = data.timestamp;
    } else {
      _mails = {};
      _lastUpdate = ApiService.FALLBACK_TIME;
    }

    if (!useCacheOnly) {
      // fetch from mail server
      final start = DateTime.now();
      //_mails = await _mailFacade.fetchMessages(existing: _mails);
      _mails = await _mailFacade.fetchMessages(existing: {});

      if (_mails == null) {
        _mails = {};
        return;
      }

      final now = DateTime.now();
      PersistentService.instance.setMails(DataWithTimestamp(data: _mails, timestamp: now));
      _lastUpdate = DateTime.now();
      print('Mails fetched successfully (${now.difference(start)})');
    }
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  @override
  Duration getMaxAge() => Duration(minutes: 15);

  Future<void> disconnect() async {
    if (_mailFacade != null) {
      await _mailFacade.disconnect();
      _mailFacade = null;
    }
  }

  Map<int, MailMessage> getMailsRaw() {
    return _mails;
  }

  List<MailMessage> getMails() {
    return _mails.values.toList().reversed.toList();
  }

  Future<bool> sendMessage(MailMessageSend message) {
    final account = SettingsService.instance.getOvguAccount();
    return _mailFacade.sendMessage(message, name: account.name, password: account.password);
  }
}