import 'dart:developer';

import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/local/data_with_timestamp.dart';
import 'package:ikus_app/model/local/mail_metadata.dart';
import 'package:ikus_app/model/mail/mail_collection.dart';
import 'package:ikus_app/model/mail/mail_message.dart';
import 'package:ikus_app/model/mail/mail_message_send.dart';
import 'package:ikus_app/model/local/mail_progress.dart';
import 'package:ikus_app/model/mail/mailbox_type.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/notification_service.dart';
import 'package:ikus_app/service/persistent_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/mail_facade.dart';

class MailService implements SyncableService {

  static const String LOG_NAME = 'Mail';
  static final MailService _instance = MailService();
  static MailService get instance => _instance;

  final MailProgress _progress = MailProgress();
  late MailMetadata _mailMetadata;
  MailCollection? _lastFetchResult; // nullable, only exists if fetched using network at least once

  @override
  String id = 'MAIL';

  @override
  String getDescription() => t.sync.items.emails;

  @override
  Future<void> sync({required bool useNetwork, String? useJSON, bool showNotifications = false, AddFutureCallback? onBatchFinished}) async {

    assert(useJSON == null, "mail service sync cannot handle json");

    if (_progress.active) {
      log(' -> Already syncing mails', name: LOG_NAME);
      return;
    }

    log(' -> Syncing mails...', name: LOG_NAME);
    _progress.reset(starting: true);

    if (!useNetwork) {
      _progress.reset();
      _mailMetadata = await PersistentService.instance.getMailMetadata();
      log(' -> Fetched mail metadata (from cache only)', name: LOG_NAME);
      return;
    }

    // fetch from mail server
    final start = DateTime.now();
    final account = SettingsService.instance.getOvguAccount();
    if (account == null) {
      _progress.reset();
      log(' -> skip mail (no ovgu account)', name: LOG_NAME);
      return;
    }

    // get current mails
    final cache = await PersistentService.instance.getAllMails();

    Set<int>? prevInboxMails;
    if (showNotifications) {
      prevInboxMails = cache.inbox.keys.toSet();
    }

    Map<int, MailMessage>? inbox = await MailFacade.fetchMessages(
      mailbox: MailboxType.INBOX,
      existing: cache.inbox,
      name: account.name,
      password: account.password,
      progressCallback: (curr, total) {
        _progress.curr = curr;
        _progress.total = total;
        _progress.percent = (curr / total.toDouble()) * 0.7;
      }
    );

    _progress.mailbox = MailboxType.SENT;
    _progress.curr = 0;
    _progress.total = 0;
    _progress.percent = 0.7;
    Map<int, MailMessage>? sent = await MailFacade.fetchMessages(
      mailbox: MailboxType.SENT,
      existing: cache.sent,
      name: account.name,
      password: account.password,
      progressCallback: (curr, total) {
        _progress.curr = curr;
        _progress.total = total;
        _progress.percent = 0.7 + (curr / total.toDouble()) * 0.3;
      }
    );

    if (inbox == null || sent == null) {
      _progress.reset();
      log(' -> Mail update failed', name: LOG_NAME);
      return;
    }

    final newMailCollection = MailCollection(inbox: inbox, sent: sent);

    // show notifications
    if (showNotifications && prevInboxMails != null) {
      final List<MailMessage> newMails = newMailCollection.inbox.values
          .where((mail) => !prevInboxMails!.contains(mail.uid))
          .toList();

      if (newMails.isNotEmpty) {
        final showNotification = () => NotificationService.createInstance().showNewMail(newMails);

        if (onBatchFinished != null) {
          // show at the end of batch update
          onBatchFinished(showNotification);
        } else {
          // show immediately
          showNotification();
        }
      }
    }

    final now = DateTime.now();
    await PersistentService.instance.setMails(DataWithTimestamp(data: newMailCollection, timestamp: now));
    _mailMetadata = MailMetadata(
      timestamp: now,
      countInbox: newMailCollection.inbox.length,
      countSent: newMailCollection.sent.length
    );
    _lastFetchResult = newMailCollection;
    _progress.reset();
    log(' -> Mails updated (${now.difference(start)})', name: LOG_NAME);
  }

  @override
  DateTime getLastUpdate() {
    return _mailMetadata.timestamp ?? ApiService.FALLBACK_TIME;
  }

  @override
  Duration maxAge = Duration(minutes: 15);

  @override
  String? get batchKey => null; // not available in batch route

  MailMetadata getMailMetadata() {
    return _mailMetadata;
  }

  Future<List<MailMessage>> getMails({required MailboxType mailbox, required int startIndex, required int size}) async {
    return await PersistentService.instance.getMails(
      mailbox: mailbox,
      startIndex: startIndex,
      size: size
    );
  }

  Future<MailMessage?> getMail(MailboxType mailbox, int uid) async {
    return await PersistentService.instance.getMail(mailbox, uid);
  }

  MailCollection? getLastFetchResult() {
    return _lastFetchResult;
  }

  Future<bool> sendMessage(MailMessageSend message) {
    final account = SettingsService.instance.getOvguAccount();
    if (account == null)
      return Future.value(false);
    return MailFacade.sendMessage(message, name: account.name, password: account.password);
  }

  Future<bool> deleteMessage(MailboxType mailbox, int uid) {
    final account = SettingsService.instance.getOvguAccount();
    if (account == null)
      return Future.value(false);
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