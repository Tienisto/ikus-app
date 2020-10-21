import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/quadratic_button.dart';
import 'package:ikus_app/components/cards/mail_card.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/mail_message.dart';
import 'package:ikus_app/model/ovgu_account.dart';
import 'package:ikus_app/screens/mail_message_screen.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/mail_facade.dart';
import 'package:ikus_app/utility/ui.dart';

class MailScreen extends StatefulWidget {

  @override
  _MailScreenState createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> {

  List<MailMessage> mails = [];

  @override
  void initState() {
    super.initState();
    sync();
  }

  Future<void> sync() async {
    OvguAccount account = SettingsService.instance.getOvguAccount();
    var client = await MailFacade.connect(name: account.name, password: account.password);
    if (client == null)
      return;
    var messages = await client.fetchMessages();
    setState(() {
      mails = messages;
    });
  }

  @override
  Widget build(BuildContext context) {

    double width = min(MediaQuery.of(context).size.width, OvguPixels.maxWidth);
    const int btnCount = 3;
    const double btnMargin = 20;
    const double btnFontSize = 14;
    double btnWidth = (width - btnMargin * (btnCount - 1) - OvguPixels.mainScreenPadding.horizontal) / btnCount;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
        title: Text(t.mails.title)
      ),
      body: MainListView(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuadraticButton(
                    icon: Icons.build,
                    text: t.mails.actions.account,
                    width: btnWidth,
                    fontSize: btnFontSize,
                    callback: () async {}
                ),
                QuadraticButton(
                    icon: Icons.sync,
                    text: t.mails.actions.sync,
                    width: btnWidth,
                    fontSize: btnFontSize,
                    callback: () async {}
                ),
                QuadraticButton(
                    icon: Icons.send,
                    text: t.mails.actions.send,
                    width: btnWidth,
                    fontSize: btnFontSize,
                    callback: () { }
                )
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(t.mails.mails, style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 20),
          ...mails.map((mail) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: MailCard(
                mail: mail,
                callback: () async {
                  pushScreen(context, () => MailMessageScreen(
                    mail: mail,
                    onReply: () {
                      Navigator.pop(context);
                    },
                    onDelete: () {
                      Navigator.pop(context);
                      sync();
                    },
                  ));
                }
              ),
            );
          }),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}