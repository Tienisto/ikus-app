import 'package:flutter/material.dart';
import 'package:ikus_app/components/badge.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/html_view.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/mail_message.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class MailMessageScreen extends StatelessWidget {

  final MailMessage mail;
  final Callback onReply;
  final Callback onDelete;

  const MailMessageScreen({@required this.mail, @required this.onReply, @required this.onDelete});

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
                Center(child: Badge(text: mail.from)),
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
                type: OvguButtonType.ICON_WIDE,
                callback: onDelete,
                child: Icon(Icons.delete),
              ),
              OvguButton(
                flat: true,
                type: OvguButtonType.ICON_WIDE,
                callback: onReply,
                child: Icon(Icons.reply),
              )
            ],
          ),
          SizedBox(height: 30),
          HtmlView(
            padding: EdgeInsets.symmetric(horizontal: 12),
            html: mail.content
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}