import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:ikus_app/model/mail/mail_message.dart';
import 'package:ikus_app/model/mail/mail_message_send.dart';
import 'package:ikus_app/model/mail/mailbox_type.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/utility/callbacks.dart';

enum PartType {
  MULTIPART, PLAIN, HTML, OTHER
}

class PartMetadata {
  final String path;
  final PartType type;
  final String? encoding;
  final String? charset;

  PartMetadata(this.path, this.type, this.encoding, this.charset);
}

class MailFacade {

  static const String LOG_NAME = 'Mail';
  static const Duration MAILS_YOUNGER_THAN = Duration(days: 90);
  static const String MAILBOX_PATH_INBOX = "INBOX";
  static const String MAILBOX_PATH_SEND = "INBOX.Sent";

  static Future<bool> testLogin({required String name, required String password}) async {
    try {
      final client = ImapClient();
      await client.connectToServer('cyrus.ovgu.de', 993);
      await client.login(name, password);
      await client.disconnect();
      return true;
    } catch (e) {
      log(e.toString(), error: e, name: LOG_NAME);
      return false;
    }
  }

  /// Fetches mails younger than [MAILS_YOUNGER_THAN].
  /// Use existing mails to reduce fetch amount
  static Future<Map<int, MailMessage>?> fetchMessages({required MailboxType mailbox, required String name, required String password, required Map<int, MailMessage> existing, MailProgressCallback? progressCallback}) async {
    try {
      final imapClient = await getImapClient(name: name, password: password);
      await imapClient.selectMailboxByPath(mailbox.path);

      final ids = await imapClient.uidSearchMessages(searchCriteria: 'YOUNGER ${MAILS_YOUNGER_THAN.inSeconds}');

      final fetchSequence = MessageSequence();
      final resultMap = Map<int, MailMessage>();
      ids.matchingSequence?.toList().forEach((id) {
        MailMessage? message = existing[id];
        if (message != null)
          resultMap[id] = message; // add existing message
        else
          fetchSequence.add(id); // add to fetch list (will be fetched in the next step)
      });

      log(' -> Provided ${existing.length} cached mails, need to fetch ${fetchSequence.length}.', name: LOG_NAME);

      if (fetchSequence.isEmpty) {
        return resultMap; // all mails has already been fetched (no new mails)
      }

      final fetchIdMap = Map<int, List<PartMetadata>>();
      final fetchResponse = await imapClient.uidFetchMessages(fetchSequence, '(BODYSTRUCTURE)');

      for (final m in fetchResponse.messages) {
        final uid = m.uid;
        if (uid == null)
          continue;

        if (m.body?.parts == null) {
          final type = getPartType(m.mediaType.sub);
          final encoding = m.body?.encoding;
          final charset = m.body?.contentType?.charset;
          fetchIdMap[uid] = [PartMetadata("1", type, encoding, charset)];
        } else {
          List<PartMetadata> list = [];
          _addTextParts(m.body?.parts ?? [], list);
          fetchIdMap[uid] = list;
        }
      }

      int curr = 0;
      int errors = 0;
      for (final mail in fetchIdMap.entries) {
        try {
          if (progressCallback != null) {
            curr++;
            progressCallback(curr, fetchIdMap.length);
          }

          final uid = mail.key;
          final partMetadata = mail.value;
          final fetchSequence = MessageSequence()..add(uid);
          final bodies = mail.value.map((part) => 'BODY[${part.path}]').join(' ');
          final res = await imapClient.uidFetchMessages(fetchSequence, '(ENVELOPE $bodies)');
          final mailResponse = res.messages.first;
          final PartMetadata? htmlPart = partMetadata.firstWhereOrNull((part) => part.type == PartType.HTML);
          final PartMetadata? plainPart = partMetadata.firstWhereOrNull((part) => part.type == PartType.PLAIN);
          String? plain;
          String? html;

          if (plainPart != null) {
            final part = mailResponse.getPart(plainPart.path)!;
            plain = part.mimeData?.decodeText(ContentTypeHeader.from(MediaType.textPlain, charset: plainPart.charset), plainPart.encoding);
          }

          if (htmlPart != null) {
            final part = mailResponse.getPart(htmlPart.path)!;
            html = part.mimeData?.decodeText(ContentTypeHeader.from(MediaType.textPlain, charset: htmlPart.charset), htmlPart.encoding);
          }

          resultMap[uid] = MailMessage(
            uid: uid,
            from: mailResponse.fromEmail ?? 'unknown',
            to: mailResponse.to?.map((m) => m.email).toList() ?? [],
            cc: mailResponse.cc?.map((m) => m.email).toList() ?? [],
            timestamp: mailResponse.decodeDate()?.toLocal() ?? ApiService.FALLBACK_TIME,
            subject: mailResponse.decodeSubject() ?? '',
            contentPlain: plain,
            contentHtml: html
          );

        } catch (e) {
          errors++;
          log(e.toString(), error: e, name: LOG_NAME);
        }
      }

      try {
        await imapClient.disconnect();
      } catch (e) {
        log(' -> IMAP logout failed', name: LOG_NAME);
      }

      log(' -> Fetched ($errors errors / ${fetchIdMap.length} total)', name: LOG_NAME);

      return resultMap;
    } catch (e) {
      log(e.toString(), error: e, name: LOG_NAME);
      return null;
    }
  }

  static Future<bool> deleteMessage({required MailboxType mailbox, required int uid, required String name, required String password}) async {
    try {
      final imapClient = await getImapClient(name: name, password: password);
      await imapClient.selectMailboxByPath(mailbox.path);
      final uidSequence = MessageSequence()..add(uid);
      await imapClient.uidMarkDeleted(uidSequence);
      await imapClient.expunge();
      await imapClient.disconnect();
      return true;
    } catch (e) {
      log(e.toString(), error: e, name: LOG_NAME);
      return false;
    }
  }

  static Future<bool> sendMessage(MailMessageSend message, {required String name, required String password}) async {

    try {
      final smtpClient = SmtpClient('ovgu.de');
      await smtpClient.connectToServer('mail.ovgu.de', 587, isSecure: false);
      final ehloResponse = await smtpClient.ehlo();
      if (ehloResponse.isFailedStatus) {
        return false;
      }

      final tlsResponse = await smtpClient.startTls();
      if (tlsResponse.isFailedStatus)
        return false;

      final loginResponse = await smtpClient.authenticate(name, password);
      if (loginResponse.isFailedStatus)
        return false;

      final sendResponse = await smtpClient.sendMessage(message.toMimeMessage());
      if (sendResponse.isFailedStatus)
        return false;

      await smtpClient.disconnect();

      // add email to sent folder
      final imapClient = await getImapClient(name: name, password: password);
      await imapClient.appendMessage(message.toMimeMessage(), targetMailboxPath: MAILBOX_PATH_SEND);
      await imapClient.disconnect();

      return true;
    } catch (e) {
      log(e.toString(), error: e, name: LOG_NAME);
      return false;
    }
  }

  // for enough_mail (not using yet)
  static void _addTextParts(List<BodyPart> parts, List<PartMetadata> result) {
    for (final part in parts) {
      final contentType = part.contentType;
      if (contentType != null && contentType.mediaType.isText) {
        final path = part.fetchId;
        final type = getPartType(contentType.mediaType.sub);
        final encoding = part.encoding;
        final charset = contentType.charset;

        if (path != null)
          result.add(PartMetadata(path, type, encoding, charset));
      } else {
        _addTextParts(part.parts ?? [], result);
      }
    }
  }

  static PartType getPartType(MediaSubtype type) {
    switch (type) {
      case MediaSubtype.textPlain: return PartType.PLAIN;
      case MediaSubtype.textHtml: return PartType.HTML;
      default: return PartType.OTHER;
    }
  }

  static Future<ImapClient> getImapClient({required String name, required String password}) async {
    final imapClient = ImapClient();
    await imapClient.connectToServer('cyrus.ovgu.de', 993);
    await imapClient.login(name, password);
    return imapClient;
  }
}