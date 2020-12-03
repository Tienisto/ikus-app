import 'dart:math';

import 'package:enough_mail/codecs/date_codec.dart';
import 'package:enough_mail/enough_mail.dart' as enough_mail;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/model/mail_message.dart';
import 'package:ikus_app/model/mail_message_send.dart';
import 'package:ikus_app/model/mailbox_type.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:imap_client/imap_client.dart';

enum PartType {
  MULTIPART, PLAIN, HTML, OTHER
}

class PartMetadata {
  final String path;
  final PartType type;
  final String encoding; // nullable
  final String charset; // nullable

  PartMetadata(this.path, this.type, this.encoding, this.charset);
}

class MailFacade {

  static const Duration MAILS_YOUNGER_THAN = Duration(days: 90);
  static const String MAILBOX_PATH_INBOX = "INBOX";
  static const String MAILBOX_PATH_SEND = "INBOX.Sent";

  static Future<bool> testLogin({@required String name, @required String password}) async {
    final client = enough_mail.ImapClient();
    await client.connectToServer('cyrus.ovgu.de', 993);
    final response = await client.login(name, password);
    final ok = response.isOkStatus;
    await client.closeConnection();
    return ok;
  }

  /// Fetches mails younger than [MAILS_YOUNGER_THAN].
  /// Use existing mails to reduce fetch amount
  /// Using imap_client package for now because enough_mail cannot parse BODY[1.2.3] queries
  static Future<Map<int, MailMessage>> fetchMessages({@required MailboxType mailbox, @required String name, @required String password, @required Map<int, MailMessage> existing, MailProgressCallback progressCallback}) async {

    final imapClient = await getImapClient(name: name, password: password);
    if (imapClient == null)
      return null;

    final selectInboxResponse = await imapClient.selectMailboxByPath(mailbox.path);
    if (selectInboxResponse.isFailedStatus)
      return null;

    final ids = await imapClient.uidSearchMessages('YOUNGER ${MAILS_YOUNGER_THAN.inSeconds}');

    if (ids.isFailedStatus)
      return null;

    final fetchSequence = enough_mail.MessageSequence();
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

    final fetchIdMap = Map<int, List<PartMetadata>>();
    final fetchResponse = await imapClient.uidFetchMessages(fetchSequence, '(BODYSTRUCTURE)');
    if (fetchResponse.isFailedStatus)
      return null;

    fetchResponse.result.messages.forEach((m) {
      if (m.body.parts == null) {
        final type = getPartType(m.mediaType.sub);
        final encoding = m.body.encoding;
        final charset = m.body.contentType.charset;
        fetchIdMap[m.uid] = [PartMetadata("1", type, encoding, charset)];
      } else {
        List<PartMetadata> list = List();
        _addTextParts(m.body.parts, list);
        fetchIdMap[m.uid] = list;
      }
    });

    try {
      await imapClient.closeConnection();
    } catch (e) {
      print(' -> IMAP logout failed');
    }

    // using imap_client package because enough_mail cannot handle specific BODY[x] queries
    // TODO: migrate when enough_mail has fixed this
    ImapClient fallbackClient = ImapClient();
    await fallbackClient.connect('cyrus.ovgu.de', 993, true);
    await fallbackClient.login(name, password);
    ImapFolder box = await fallbackClient.getFolder(mailbox.path);

    // now fetch the actual content of each mail
    int curr = 0;
    int errors = 0;
    for (final mail in fetchIdMap.entries) {

      final id = mail.key;

      if (progressCallback != null) {
        curr++;
        progressCallback(curr, fetchIdMap.length);
      }

      try {
        final partMetadata = mail.value;
        final bodies = partMetadata.map((part) => 'BODY[${part.path}]');
        final response = await box.fetch(['ENVELOPE', ...bodies], messageIds: [id], uid: true);
        final map = response.entries.first.value;

        final String from = getMailAddress(map['ENVELOPE']['from']).firstWhere((element) => true, orElse: () => 'unknown');
        final String to = getMailAddress(map['ENVELOPE']['to']).firstWhere((element) => true, orElse: () => 'unknown');
        final List<String> cc = getMailAddress(map['ENVELOPE']['cc']);
        final String subject = enough_mail.MailCodec.decodeHeader(map['ENVELOPE']['subject']);
        final PartMetadata htmlPart = partMetadata.firstWhere((part) => part.type == PartType.HTML, orElse: () => null);
        final PartMetadata plainPart = partMetadata.firstWhere((part) => part.type == PartType.PLAIN, orElse: () => null);
        String html;
        String plain;

        if (htmlPart != null) {
          html = enough_mail.MailCodec.decodeAnyText(map['BODY[${htmlPart.path}]'], htmlPart.encoding, htmlPart.charset);
        }

        if (plainPart != null) {
          plain = enough_mail.MailCodec.decodeAnyText(map['BODY[${plainPart.path}]'], plainPart.encoding, plainPart.charset);
        }

        resultMap[id] = MailMessage(
          uid: id,
          from: from,
          to: to,
          cc: cc,
          timestamp: DateCodec.decodeDate(map['ENVELOPE']['date']) ?? ApiService.FALLBACK_TIME,
          subject: subject,
          preview: (plain?.substring(0, min(plain.length, 100))?.replaceAll('\r\n', ' ') ?? '') + '...',
          content: html ?? plain?.replaceAll('\r\n', '<br>') ?? ''
        );
      } catch (e) {
        errors++;
        print(' -> Fetch error (uid = $id) ($e)');

        // reinitialize because the current connection is dirty
        fallbackClient = ImapClient();
        await fallbackClient.connect("cyrus.ovgu.de", 993, true);
        await fallbackClient.login(name, password);
        box = await fallbackClient.getFolder(mailbox.path);
      }
    }

    try {
      await fallbackClient.logout();
    } catch (e) {
      print(' -> IMAP logout failed');
    }

    print(' -> Fetched ($errors errors / ${fetchIdMap.length} total)');

    return resultMap;
  }

  static Future<bool> deleteMessage({@required MailboxType mailbox, @required int uid, @required String name, @required String password}) async {
    final imapClient = await getImapClient(name: name, password: password);
    if (imapClient == null)
      return false;

    final selectInboxResponse = await imapClient.selectMailboxByPath(mailbox.path);
    if (selectInboxResponse.isFailedStatus)
      return null;

    final uidSequence = enough_mail.MessageSequence()..add(uid);
    final markResponse = await imapClient.uidMarkDeleted(uidSequence);
    if (markResponse.isFailedStatus)
      return false;

    final deleteResponse = await imapClient.expunge();
    if (deleteResponse.isFailedStatus)
      return false;

    await imapClient.closeConnection();

    return true;
  }

  static Future<bool> sendMessage(MailMessageSend message, {@required String name, @required String password}) async {

    final client = enough_mail.SmtpClient('ovgu.de');
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

    await client.closeConnection();

    // add email to sent folder
    final imapClient = await getImapClient(name: name, password: password);
    if (imapClient == null)
      return false;
    await imapClient.appendMessage(message.toMimeMessage(), targetMailboxPath: MAILBOX_PATH_SEND);
    await imapClient.closeConnection();
    return true;
  }

  // for enough_mail (not using yet)
  static void _addTextParts(List<enough_mail.BodyPart> parts, List<PartMetadata> result) {
    parts.forEach((part) {
      if (part.contentType.mediaType.isText) {
        final path = part.fetchId;
        final type = getPartType(part.contentType.mediaType.sub);
        final encoding = part.encoding;
        final charset = part.contentType.charset;
        result.add(PartMetadata(path, type, encoding, charset));
      } else if (part.parts != null) {
        _addTextParts(part.parts, result);
      }
    });
  }

  static PartType getPartType(enough_mail.MediaSubtype type) {
    switch (type) {
      case enough_mail.MediaSubtype.textPlain: return PartType.PLAIN;
      case enough_mail.MediaSubtype.textHtml: return PartType.HTML;
      default: return PartType.OTHER;
    }
  }

  /// takes the last 2 parts of the mail address (ignoring personal name for now)
  static List<String> getMailAddress(List<List<String>> raw) {
    if (raw == null)
      return [];
    return raw.map((address) => address[address.length - 2] + '@' + address.last).toList();
  }

  static Future<enough_mail.ImapClient> getImapClient({@required String name, @required String password}) async {
    final imapClient = enough_mail.ImapClient();
    await imapClient.connectToServer('cyrus.ovgu.de', 993);
    final response = await imapClient.login(name, password);
    if (response.isFailedStatus)
      return null;

    return imapClient;
  }
}