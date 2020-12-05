import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/data_with_timestamp.dart';
import 'package:ikus_app/model/mail_collection.dart';
import 'package:ikus_app/model/mail_message.dart';
import 'package:ikus_app/model/mail_message_send.dart';
import 'package:ikus_app/model/mailbox_type.dart';
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
  Future<void> sync({bool useNetwork, String useJSON}) async {

    assert(useJSON == null, "mail service sync cannot handle json");

    if (_progress.active) {
      print(' -> Already syncing mails');
      return;
    }

    print(' -> Syncing mails...');
    _progress.active = true;
    _progress.mailbox = MailboxType.INBOX;
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

    if (useNetwork) {
      // fetch from mail server
      final start = DateTime.now();
      final account = SettingsService.instance.getOvguAccount();
      if (account == null) {
        _progress.active = false;
        print(' -> skip mail (no ovgu account)');
        return;
      }

      Map<int, MailMessage> inbox = await MailFacade.fetchMessages(
        mailbox: MailboxType.INBOX,
        existing: _mails.inbox,
        name: account.name,
        password: account.password,
        progressCallback: (curr, total) {
          _progress.curr = curr;
          _progress.total = total;
        }
      );

      _progress.mailbox = MailboxType.SENT;
      _progress.curr = 0;
      _progress.total = 0;
      Map<int, MailMessage> sent = await MailFacade.fetchMessages(
        mailbox: MailboxType.SENT,
        existing: _mails.sent,
        name: account.name,
        password: account.password,
        progressCallback: (curr, total) {
          _progress.curr = curr;
          _progress.total = total;
        }
      );

      if (inbox == null || sent == null) {
        _progress.active = false;
        print(' -> Mail update failed');
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
  Duration maxAge = Duration(minutes: 30);

  @override
  String batchKey; // not available in batch route

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

  Future<bool> deleteMessage(MailboxType mailbox, int uid) {
    final account = SettingsService.instance.getOvguAccount();
    return MailFacade.deleteMessage(mailbox: mailbox, uid: uid, name: account.name, password: account.password);
  }

  MailProgress getProgress() {
    return _progress;
  }

  Future<void> deleteCache() async {
    await PersistentService.instance.deleteMailCache();
    await sync(useNetwork: false);
  }
}