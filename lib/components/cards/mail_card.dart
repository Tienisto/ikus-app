import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card_with_header.dart';
import 'package:ikus_app/model/mail_message.dart';
import 'package:ikus_app/model/mailbox_type.dart';
import 'package:ikus_app/utility/callbacks.dart';

class MailCard extends StatelessWidget {

  final MailMessage mail;
  final MailboxType mailbox;
  final Callback callback;

  const MailCard({@required this.mail, @required this.mailbox, @required this.callback});

  @override
  Widget build(BuildContext context) {
    return OvguCardWithHeader(
      onTap: callback,
      left: mailbox == MailboxType.INBOX ? mail.from : mail.to,
      right: mail.formattedTimestamp,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mail.subject, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(mail.preview),
          ],
        ),
      )
    );
  }
}
