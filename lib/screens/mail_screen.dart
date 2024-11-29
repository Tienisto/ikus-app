import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ikus_app/components/animated_progress_bar.dart';
import 'package:ikus_app/components/buttons/quadratic_button.dart';
import 'package:ikus_app/components/cards/mail_card.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/mail/mail_collection.dart';
import 'package:ikus_app/model/mail/mail_message.dart';
import 'package:ikus_app/model/local/mail_progress.dart';
import 'package:ikus_app/model/mail/mailbox_type.dart';
import 'package:ikus_app/screens/mail_message_screen.dart';
import 'package:ikus_app/screens/mail_send_screen.dart';
import 'package:ikus_app/screens/ovgu_account_screen.dart';
import 'package:ikus_app/service/mail_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class MailScreen extends StatefulWidget {

  final int? openUid;

  const MailScreen({this.openUid});

  @override
  _MailScreenState createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> {

  static const String LOG_NAME = 'MailScreen';
  static const PRE_WIDGET_COUNT = 7;
  static const POST_WIDGET_COUNT = 1;

  MailboxType mailbox = MailboxType.INBOX;
  bool switching = false; // flag for switch inbox/sent folder
  bool fetching = false; // flag if fetching data from storage
  Map<int, MailMessage> mails = {}; // mails are fetched lazily
  int mailCount = 0; // total count of mails of current mailbox (not only in cache, total!)
  String? progressString;
  double? progressPercent;
  bool syncing = false;

  @override
  void initState() {
    super.initState();
    postInit();
  }

  Future<void> postInit() async {
    await prefetch(mailbox: mailbox, missIndex: 0); // fetch first mails
    updateMailCount(mailbox);
    if (MailService.instance.getProgress().active) {
      nextFrame(() {
        syncing = true;
        updateProgressString(MailService.instance.getProgress());
        startProgressTimer();
      });
    }
    await handleUid();
  }

  void updateMailCount(MailboxType mailbox) {
    final metadata = MailService.instance.getMailMetadata();
    setState(() {
      mailCount = mailbox == MailboxType.INBOX ? metadata.countInbox : metadata.countSent;
    });
  }

  void resetCache() {
    setState(() {
      mails = {};
    });
  }

  /// get mails from missing index and also some additional mails
  Future<void> prefetch({required MailboxType mailbox, required int missIndex, bool clearOld = false}) async {
    if (fetching || MailService.instance.getProgress().active)
      return;

    fetching = true;
    log('Fetch index $missIndex', name: LOG_NAME);
    final fetched = await MailService.instance.getMails(mailbox: mailbox, startIndex: missIndex, size: 10);
    setState(() {
      if (clearOld)
        mails = {};
      for(int i = 0; i < fetched.length; i++) {
        mails[missIndex + i] = fetched[i];
      }
      fetching = false;
    });
  }

  /// use data from last sync to avoid additional fetching
  void applyLastSyncResult(MailCollection lastResult) {
    resetCache();
    final mailsList = mailbox == MailboxType.INBOX ? lastResult.inbox : lastResult.sent;
    final mailsReversed = mailsList.entries.toList().reversed.toList();
    for (int i = 0; i < mailsReversed.length; i++) {
      mails[i] = mailsReversed[i].value;
    }
    mailCount = mails.length;
  }

  void startProgressTimer() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {

      final progress = MailService.instance.getProgress();
      if (!mounted || !progress.active) {
        timer.cancel();

        if (mounted) {
          setState(() {
            progressString = null;
            progressPercent = 1;
            syncing = false;

            final lastResult = MailService.instance.getLastFetchResult();
            if (lastResult != null) {
              applyLastSyncResult(lastResult);
            }
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
      final mail = await MailService.instance.getMail(MailboxType.INBOX, widget.openUid!);
      if (mail != null) {
        nextFrame(() {
          pushScreen(context, () => getMailMessageScreen(mail));
        });
      }
    }
  }

  Future<void> sync() async {
    setState(() {
      syncing = true;
      progressPercent = 0;
      progressString = null;
    });
    await sleep(200); // wait for animation
    MailService.instance.sync(useNetwork: true, showNotifications: true);
    startProgressTimer();
  }

  Future<void> toggleMailState() async {
    if (switching)
      return;
    switching = true;
    setState(() {});

    MailboxType newMailbox;
    switch (mailbox) {
      case MailboxType.INBOX:
        newMailbox = MailboxType.SENT;
        break;
      case MailboxType.SENT:
        newMailbox = MailboxType.INBOX;
        break;
    }

    await prefetch(mailbox: newMailbox, missIndex: 0, clearOld: true);
    updateMailCount(newMailbox);
    setState(() {
      mailbox = newMailbox;
      switching = false;
    });
  }

  Future<void> pushSendScreen(MailMessage? reply) async {
    bool sent = false;
    String? content;
    if (reply != null) {
      String plain = reply.getPlainOrParseHtml();
      content = '\n\n> ${t.mails.replyPrefix}${reply.from}:\n>\n> '+plain.split('\n').join('\n> ');
    }
    await pushScreen(context, () => MailSendScreen(
      onSend: () => sent = true,
      to: reply?.from,
      cc: reply?.cc,
      subject: reply != null ? 'Re: ${reply.subject}' : null,
      content: content,
    ));
    if (sent) {
      await sync();
    }
  }

  List<Widget> getPreWidgets(BuildContext context) {
    double width = math.min(MediaQuery.of(context).size.width, OvguPixels.maxWidth);
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
                    resetCache();
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
                  await pushSendScreen(null);
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
                  Text(progressString != null ? t.mails.sync(text: progressString!) : '')
                ],
              ),
            ),
          ),
        ),
        secondChild: Container(),
        crossFadeState: syncing ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: Duration(milliseconds: 200)
      )
    ];
  }

  Widget getMailMessageScreen(MailMessage mail) {
    return MailMessageScreen(
      mail: mail,
      mailbox: mailbox,
      onReply: () {
        pushSendScreen(mail);
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
          title: Text(t.mails.title)
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 0, maxWidth: OvguPixels.maxWidth),
          child: ListView.builder(
            itemCount: PRE_WIDGET_COUNT + mailCount + POST_WIDGET_COUNT,
            itemBuilder: (context, index) {
              if (index >= PRE_WIDGET_COUNT && index < PRE_WIDGET_COUNT + mailCount) {
                MailMessage? mail = mails[index - PRE_WIDGET_COUNT];
                if (mail == null) {
                  prefetch(mailbox: mailbox, missIndex: index - PRE_WIDGET_COUNT);
                  return Container();
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: MailCard(
                    mail: mail,
                    mailbox: mailbox,
                    callback: () async {
                      pushScreen(context, () => getMailMessageScreen(mail));
                    }
                  )
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
