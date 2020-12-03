import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/model/mail_message.dart';
import 'package:ikus_app/model/mailbox_type.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class MailCard extends StatelessWidget {

  final MailMessage mail;
  final MailboxType mailbox;
  final Callback callback;

  const MailCard({@required this.mail, @required this.mailbox, @required this.callback});

  @override
  Widget build(BuildContext context) {
    return OvguCard(
      child: InkWell(
        customBorder: OvguPixels.shape,
        onTap: callback,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      height: 25,
                      decoration: BoxDecoration(
                        color: OvguColor.primary,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(OvguPixels.borderRadiusPlain), bottomRight: Radius.circular(OvguPixels.borderRadiusPlain))
                      ),
                      child: FittedBox(
                        // FittedBox scales the text down if it is too large
                        child: Text(mailbox == MailboxType.INBOX ? mail.from : mail.to, style: TextStyle(color: Colors.white))
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(mail.formattedTimestamp, style: TextStyle(color: OvguColor.secondaryDarken2)),
                )
              ],
            ),
            Padding(
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
          ],
        ),
      ),
    );
  }
}
