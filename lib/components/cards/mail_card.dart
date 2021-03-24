import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card_with_header.dart';
import 'package:ikus_app/model/mail/mail_message.dart';
import 'package:ikus_app/model/mail/mailbox_type.dart';
import 'package:ikus_app/utility/callbacks.dart';

class MailCard extends StatelessWidget {

  final MailMessage mail;
  final MailboxType mailbox;
  final Callback callback;

  const MailCard({required this.mail, required this.mailbox, required this.callback});

  String getPreview(MailMessage mail) {
    final plain = mail.getPlainOrParseHtml();
    final length = plain.length;
    String preview = plain.substring(0, min(length, 100)).replaceAll('\n', ' ').replaceAll('\r\n', ' ');
    if (length > 100) {
      preview += '...';
    }
    return preview;
  }

  @override
  Widget build(BuildContext context) {
    return OvguCardWithHeader(
      onTap: callback,
      left: mailbox == MailboxType.INBOX ? mail.from : mail.to.firstWhere((to) => true, orElse: () => ''),
      right: mail.formattedTimestamp,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mail.subject, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(getPreview(mail)),
          ],
        ),
      )
    );
  }
}
