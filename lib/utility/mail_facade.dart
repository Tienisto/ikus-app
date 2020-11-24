import 'dart:math';

import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/model/mail_message.dart';
import 'package:ikus_app/model/mail_message_send.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class MailFacade {

  final ImapClient imapClient;

  MailFacade(this.imapClient);

  static Future<MailFacade> connect({@required String name, @required String password}) async {

    final client = ImapClient();
    await client.connectToServer('cyrus.ovgu.de', 993);
    final response = await client.login(name, password);

    if (!response.isOkStatus)
      return null;

    final listResponse = await client.selectInbox();

    if (!listResponse.isOkStatus)
      return null;

    return MailFacade(client);
  }

  Future<List<MailMessage>> fetchMessages() async {
    var fetchResponse = await imapClient.fetchRecentMessages(messageCount: 10);

    if (!fetchResponse.isOkStatus)
      return [];

    return fetchResponse.result.messages.map((m) {
      String plain = m.decodeTextPlainPart();
      String html = m.decodeTextHtmlPart();
      String preview = (plain?.substring(0, min(plain.length, 100))?.replaceAll('\r\n', ' ') ?? '') + '...';
      return MailMessage(
        from: m.fromEmail,
        timestamp: m.decodeDate()?.toLocal() ?? ApiService.FALLBACK_TIME,
        subject: m.decodeSubject(),
        preview: preview,
        content: html ?? plain?.replaceAll('\r\n', '<br>') ?? ''
      );
    }).toList().reversed.toList();
  }

  Future<bool> sendMessage(MailMessageSend message, {@required String name, @required String password}) async {
    final smtpConfig = SmtpServer('mail.ovgu.de', username: name, password: password);
    final smtpMessage = Message()
      ..from = message.from
      ..recipients = [ message.to ]
      ..ccRecipients = message.cc
      ..subject = message.subject
      ..text = message.content;

    try {
      await send(smtpMessage, smtpConfig);
      return true;
    } on MailerException catch (_) {
      return false;
    }
  }
}