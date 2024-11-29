import 'package:flutter/material.dart';
import 'package:ikus_app/components/popups/generic_info_popup.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/mail/mail_message.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/popups.dart';

class MailPeoplePopup extends StatelessWidget {

  final MailMessage mail;

  const MailPeoplePopup(this.mail);

  static void open({required BuildContext context, required MailMessage mail}) {
    Popups.generic(
        context: context,
        height: 250,
        body: MailPeoplePopup(mail)
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericInfoPopup(
        title: t.popups.mailPeople.title,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 15),
          child: ListView(
            physics: Adaptive.getScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              Text(t.popups.mailPeople.from, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(mail.from),
              SizedBox(height: 10),
              Text(t.popups.mailPeople.to, style: TextStyle(fontWeight: FontWeight.bold)),
              ...mail.to.map((to) => Text(to)),
              SizedBox(height: 10),
              Text(t.popups.mailPeople.cc, style: TextStyle(fontWeight: FontWeight.bold)),
              ...mail.cc.map((cc) => Text(cc)),
              if (mail.cc.isEmpty)
                Text('-'),
              SizedBox(height: 30),
            ],
          ),
        )
    );
  }
}
