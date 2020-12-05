import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ikus_app/components/animated_progress_bar.dart';
import 'package:ikus_app/components/buttons/quadratic_button.dart';
import 'package:ikus_app/components/cards/mail_card.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/popups/wip_popup.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/mail_message.dart';
import 'package:ikus_app/model/mailbox_type.dart';
import 'package:ikus_app/model/ui/mail_progress.dart';
import 'package:ikus_app/screens/mail_message_screen.dart';
import 'package:ikus_app/screens/mail_send_screen.dart';
import 'package:ikus_app/screens/ovgu_account_screen.dart';
import 'package:ikus_app/service/mail_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class MailScreen extends StatefulWidget {

  final int openUid;

  const MailScreen({this.openUid});

  @override
  _MailScreenState createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> {

  static const PRE_WIDGET_COUNT = 7;
  static const POST_WIDGET_COUNT = 1;

  MailboxType mailbox = MailboxType.INBOX;
  List<MailMessage> mails;
  String progressString;
  double progressPercent;

  @override
  void initState() {
    super.initState();
    updateMails();
    showProgress();
    handleUid();
  }

  void updateMails() {
    switch (mailbox) {
      case MailboxType.INBOX:
        mails = MailService.instance.getMailsInbox();
        break;
      case MailboxType.SENT:
        mails = MailService.instance.getMailsSent();
        break;
    }
  }

  void showProgress() {

    final initialProgress = MailService.instance.getProgress();

    if (!initialProgress.active)
      return;

    updateProgressString(initialProgress);

    Timer.periodic(Duration(milliseconds: 100), (timer) {

      final progress = MailService.instance.getProgress();
      if (!mounted || !progress.active) {
        timer.cancel();

        if (mounted) {
          setState(() {
            progressString = null;
            progressPercent = 1;
            updateMails();
          });
        }
        return;
      }

      updateProgressString(progress);
    });
  }

  void updateProgressString(MailProgress progress) {
    setState(() {
      progressPercent = progress.percent;
      final int total = progress.total;
      if (total != 0) {
        progressString = "${progress.mailbox.name} (${progress.curr} / $total)";
      } else {
        progressString = progress.mailbox.name;
      }
    });
  }

  /// open mail by uid (used by notification callback, inbox only)
  Future<void> handleUid() async {
    if (widget.openUid != null) {
      final inbox = MailService.instance.getMailsInbox();
      final mail = inbox.firstWhere((m) => m.uid == widget.openUid, orElse: () => null);
      await sleep(1000); // wait for initialization
      if (mail != null) {
        pushScreen(context, () => getMailMessageScreen(mail));
      }
    }
  }

  Future<void> sync() async {
    MailService.instance.sync(useNetwork: true, showNotifications: true);
    showProgress();
  }

  void toggleMailState() {
    setState(() {
      switch (mailbox) {
        case MailboxType.INBOX:
          mailbox = MailboxType.SENT;
          break;
        case MailboxType.SENT:
          mailbox = MailboxType.INBOX;
          break;
      }
      updateMails();
    });
  }

  List<Widget> getPreWidgets(BuildContext context) {
    double width = min(MediaQuery.of(context).size.width, OvguPixels.maxWidth);
    const int btnCount = 3;
    const double btnMargin = 20;
    const double btnFontSize = 14;
    double btnWidth = (width - btnMargin * (btnCount - 1) - OvguPixels.mainScreenPadding.horizontal) / btnCount;

    return [
      SizedBox(height: 30),
      Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 20),
        child: Text(t.mails.alpha, style: TextStyle(color: OvguColor.secondaryDarken2)),
      ),
      Padding(
        padding: OvguPixels.mainScreenPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            QuadraticButton(
                icon: Icons.person,
                text: t.mails.actions.account,
                width: btnWidth,
                fontSize: btnFontSize,
                callback: () async {
                  bool loggedIn = false;
                  await pushScreen(context, () => OvguAccountScreen(onLogin: () => loggedIn = true));
                  if (loggedIn) {
                    updateMails();
                    await sync();
                  } else if (!SettingsService.instance.hasOvguAccount()) {
                    Navigator.pop(context);
                  }
                }
            ),
            QuadraticButton(
                icon: Icons.sync,
                text: t.mails.actions.sync,
                width: btnWidth,
                fontSize: btnFontSize,
                callback: sync
            ),
            QuadraticButton(
                icon: Icons.send,
                text: t.mails.actions.send,
                width: btnWidth,
                fontSize: btnFontSize,
                callback: () async {
                  bool sent = false;
                  await pushScreen(context, () => MailSendScreen(onSend: () => sent = true));
                  if (sent) {
                    await sync();
                  }
                }
            )
          ],
        ),
      ),
      SizedBox(height: 30),
      Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: toggleMailState,
            customBorder: RoundedRectangleBorder(borderRadius: OvguPixels.borderRadius),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, top: 5, right: 20, bottom: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download_rounded, color: mailbox == MailboxType.INBOX ? Colors.black : Colors.grey[300], size: 20),
                  Icon(Icons.upload_rounded, color: mailbox == MailboxType.SENT ? Colors.black : Colors.grey[300], size: 20),
                  SizedBox(width: 10),
                  Text(mailbox.name, style: TextStyle(fontSize: 20))
                ],
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 20),
      AnimatedCrossFade(
        firstChild: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
          child: OvguCard(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  AnimatedProgressBar(
                    progress: progressPercent ?? 0,
                    reactDuration: Duration(milliseconds: 50),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(progressString != null ? t.mails.sync(text: progressString) : '')
                ],
              ),
            ),
          ),
        ),
        secondChild: Container(),
        crossFadeState: progressString != null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: Duration(milliseconds: 200)
      )
    ];
  }

  Widget getMailMessageScreen(MailMessage mail) {
    return MailMessageScreen(
      mail: mail,
      mailbox: mailbox,
      onReply: () {
        // TODO
        WipPopup.open(context);
      },
      onDelete: () async {
        sync();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final preWidgets = getPreWidgets(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: OvguColor.primary,
          title: Text(t.mails.title)
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 0, maxWidth: OvguPixels.maxWidth),
          child: ListView.builder(
            itemCount: PRE_WIDGET_COUNT + mails.length + POST_WIDGET_COUNT,
            itemBuilder: (context, index) {
              if (index >= PRE_WIDGET_COUNT && index < PRE_WIDGET_COUNT + mails.length) {
                MailMessage mail = mails[index - PRE_WIDGET_COUNT];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: MailCard(
                    mail: mail,
                    mailbox: mailbox,
                    callback: () async {
                      pushScreen(context, () => getMailMessageScreen(mail));
                    }
                  ),
                );
              } else if (index < PRE_WIDGET_COUNT) {
                return preWidgets[index];
              } else {
                return SizedBox(height: 50); // post widget
              }
            }
          ),
        ),
      ),
    );
  }
}
