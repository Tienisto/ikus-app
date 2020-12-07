import 'package:flutter/material.dart';
import 'package:ikus_app/components/badge.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/html_view.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/components/popups/error_popup.dart';
import 'package:ikus_app/components/popups/generic_text_popup.dart';
import 'package:ikus_app/components/popups/mail_delete_popup.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/mail_message.dart';
import 'package:ikus_app/model/mailbox_type.dart';
import 'package:ikus_app/service/mail_service.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class MailMessageScreen extends StatelessWidget {

  final MailMessage mail;
  final MailboxType mailbox;
  final Callback onReply;
  final Callback onDelete;

  const MailMessageScreen({@required this.mail, @required this.mailbox, @required this.onReply, @required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
        title: Text(t.mailMessage.title),
      ),
      body: MainListView(
        children: [
          SizedBox(height: 30),
          FittedBox(
            child: Row(
              children: [
                SizedBox(width: 20),
                Center(child: Badge(text: mailbox == MailboxType.INBOX ? mail.from : mail.to)),
                SizedBox(width: 10),
                Center(child: Badge(text: mail.formattedTimestamp)),
                SizedBox(width: 20),
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(mail.subject, style: TextStyle(fontSize: OvguPixels.headerSize, fontWeight: FontWeight.bold))
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 10),
              OvguButton(
                flat: true,
                callback: () {
                  MailDeletePopup.open(context: context, callback: () async {
                    Navigator.pop(context);
                    GenericTextPopup.open(context: context, text: t.mails.deleting);
                    bool result = await MailService.instance.deleteMessage(mailbox, mail.uid);
                    if (result) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      onDelete();
                    } else {
                      Navigator.pop(context);
                      ErrorPopup.open(context);
                    }
                  });
                },
                child: Icon(Icons.delete),
              ),
              OvguButton(
                flat: true,
                callback: () {
                  Navigator.pop(context);
                  onReply();
                },
                child: Icon(Icons.reply),
              ),
              SizedBox(
                width: 70,
                child: OvguButton(
                  flat: true,
                  padding: EdgeInsets.only(left: 10),
                  callback: onReply,
                  child: Row(
                    children: [
                      Icon(Icons.attach_file),
                      SizedBox(width: 5),
                      Text('?', style: TextStyle(fontSize: 16))
                    ],
                  )
                ),
              )
            ],
          ),
          SizedBox(height: 30),
          HtmlView(
            padding: EdgeInsets.symmetric(horizontal: 12),
            html: mail.contentHtml ?? mail.contentPlain.replaceAll('\n', '<br>')
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}
