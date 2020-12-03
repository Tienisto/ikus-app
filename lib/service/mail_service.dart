import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/data_with_timestamp.dart';
import 'package:ikus_app/model/mail_collection.dart';
import 'package:ikus_app/model/mail_message.dart';
import 'package:ikus_app/model/mail_message_send.dart';
import 'package:ikus_app/model/ui/mail_progress.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/persistent_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/mail_facade.dart';

class MailService implements SyncableService {

  static final MailService _instance = MailService();
  static MailService get instance => _instance;

  final MailProgress _progress = MailProgress();
  DateTime _lastUpdate;
  MailCollection _mails;

  @override
  String getName() => t.sync.items.emails;

  @override
  Future<void> sync({bool useCacheOnly}) async {

    if (_progress.active) {
      print(' -> Already syncing mails');
      return;
    }

    print(' -> Syncing mails...');
    _progress.active = true;
    _progress.mailbox = t.mails.inbox;
    _progress.curr = 0;
    _progress.total = 0;

    // load from storage
    final data = PersistentService.instance.getMails();
    if (data != null) {
      _mails = data.data;
      _lastUpdate = data.timestamp;
    } else {
      _mails = MailCollection.EMPTY;
      _lastUpdate = ApiService.FALLBACK_TIME;
    }

    if (!useCacheOnly) {
      // fetch from mail server
      final start = DateTime.now();
      final account = SettingsService.instance.getOvguAccount();
      if (account == null) {
        _progress.active = false;
        return;
      }

      Map<int, MailMessage> inbox = await MailFacade.fetchMessages(
        folder: MailFacade.MAILBOX_PATH_INBOX,
        existing: _mails.inbox,
        name: account.name,
        password: account.password,
        progressCallback: (curr, total) {
          _progress.curr = curr;
          _progress.total = total;
        }
      );

      _progress.mailbox = t.mails.sent;
      _progress.curr = 0;
      _progress.total = 0;
      Map<int, MailMessage> sent = await MailFacade.fetchMessages(
        folder: MailFacade.MAILBOX_PATH_SEND,
        existing: _mails.sent,
        name: account.name,
        password: account.password,
        progressCallback: (curr, total) {
          _progress.curr = curr;
          _progress.total = total;
        }
      );

      if (inbox == null || sent == null) {
        _mails = MailCollection.EMPTY;
        _progress.active = false;
        return;
      }

      _mails = MailCollection(inbox: inbox, sent: sent);

      final now = DateTime.now();
      PersistentService.instance.setMails(DataWithTimestamp(data: _mails, timestamp: now));
      _lastUpdate = DateTime.now();
      print(' -> Mails updated (${now.difference(start)})');
    } else {
      print(' -> Mails updated (from cache only)');
    }

    _progress.active = false;
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  @override
  Duration getMaxAge() => Duration(minutes: 30);

  List<MailMessage> getMailsInbox() {
    return _mails.inbox.values.toList().reversed.toList();
  }

  List<MailMessage> getMailsSent() {
    return _mails.sent.values.toList().reversed.toList();
  }

  Future<bool> sendMessage(MailMessageSend message) {
    final account = SettingsService.instance.getOvguAccount();
    return MailFacade.sendMessage(message, name: account.name, password: account.password);
  }

  MailProgress getProgress() {
    return _progress;
  }

  Future<void> deleteCache() async {
    await PersistentService.instance.deleteMailCache();
    await sync(useCacheOnly: true);
  }
}