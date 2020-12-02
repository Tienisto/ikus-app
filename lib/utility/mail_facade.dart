import 'dart:math';

import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/model/mail_message.dart';
import 'package:ikus_app/model/mail_message_send.dart';
import 'package:ikus_app/service/api_service.dart';

class MailFacade {

  static const Duration MAILS_YOUNGER_THAN = Duration(days: 30);
  static const String MAILBOX_PATH_SEND = "INBOX.Sent";
  final ImapClient imapClient;

  MailFacade(this.imapClient);

  static Future<bool> testLogin({@required String name, @required String password}) async {
    final client = ImapClient();
    await client.connectToServer('cyrus.ovgu.de', 993);
    final response = await client.login(name, password);
    final ok = response.isOkStatus;
    await client.closeConnection();
    return ok;
  }

  static Future<MailFacade> connect({@required String name, @required String password}) async {

    final client = ImapClient();
    await client.connectToServer('cyrus.ovgu.de', 993);
    final loginResponse = await client.login(name, password);

    if (loginResponse.isFailedStatus)
      return null;

    final selectInboxResponse = await client.selectInbox();

    if (selectInboxResponse.isFailedStatus)
      return null;

    return MailFacade(client);
  }

  Future<void> disconnect() async {
    await imapClient.closeConnection();
  }

  /// Fetches mails younger than [MAILS_YOUNGER_THAN].
  /// Use existing mails to reduce fetch amount
  Future<Map<int, MailMessage>> fetchMessages({@required Map<int, MailMessage> existing}) async {

    // TODO: choose between inbox and sent folder
    // await imapClient.selectMailboxByPath('INBOX.Sent');

    final ids = await imapClient.uidSearchMessages('YOUNGER ${MAILS_YOUNGER_THAN.inSeconds}');

    if (ids.isFailedStatus)
      return null;

    final fetchSequence = MessageSequence();
    final resultMap = Map<int, MailMessage>();
    ids.result.ids.forEach((id) {
      MailMessage message = existing[id];
      if (message != null)
        resultMap[id] = message; // add existing message
      else
        fetchSequence.add(id); // add to fetch list (will be fetched in the next step)
    });

    if (fetchSequence.isEmpty())
      return resultMap; // all mails has already been fetched (no new mails)

    final fetchResponse = await imapClient.uidFetchMessages(fetchSequence, '(FLAGS BODY[])');
    if (fetchResponse.isFailedStatus)
      return null;

    fetchResponse.result.messages.forEach((m) {
      int uid = m.uid;
      String plain = m.decodeTextPlainPart();
      String html = m.decodeTextHtmlPart();
      String preview = (plain?.substring(0, min(plain.length, 100))?.replaceAll('\r\n', ' ') ?? '') + '...';
      resultMap[uid] = MailMessage(
        uid: uid,
        from: m.fromEmail,
        timestamp: m.decodeDate()?.toLocal() ?? ApiService.FALLBACK_TIME,
        subject: m.decodeSubject(),
        preview: preview,
        content: html ?? plain?.replaceAll('\r\n', '<br>') ?? ''
      );
    });

    return resultMap;
  }

  Future<bool> sendMessage(MailMessageSend message, {@required String name, @required String password}) async {

    final client = SmtpClient('ovgu.de', isLogEnabled: true);
    await client.connectToServer('mail.ovgu.de', 587, isSecure: false);
    final ehloResponse = await client.ehlo();
    if (ehloResponse.isFailedStatus) {
      return false;
    }

    final tlsResponse = await client.startTls();
    if (tlsResponse.isFailedStatus)
      return false;

    final loginResponse = await client.login(name, password);
    if (loginResponse.isFailedStatus)
      return false;

    final sendResponse = await client.sendMessage(message.toMimeMessage());
    if (sendResponse.isFailedStatus)
      return false;

    // add email to sent folder
    await imapClient.appendMessage(message.toMimeMessage(), targetMailboxPath: MAILBOX_PATH_SEND);

    return true;
  }
}