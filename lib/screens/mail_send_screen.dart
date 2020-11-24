import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/inputs/ovgu_text_area.dart';
import 'package:ikus_app/components/inputs/ovgu_text_field.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/components/popups/error_popup.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/mail_message_send.dart';
import 'package:ikus_app/model/ovgu_account.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/mail_facade.dart';
import 'package:ikus_app/utility/popups.dart';
import 'package:ikus_app/utility/ui.dart';

class MailSendScreen extends StatefulWidget {

  final MailFacade client;
  final OvguAccount account;

  const MailSendScreen({@required this.account, @required this.client});

  @override
  _MailSendScreenState createState() => _MailSendScreenState();
}

class _MailSendScreenState extends State<MailSendScreen> {

  String _from = '';
  String _to = '';
  List<String> _cc = [];
  String _subject = '';
  String _content = '';

  Future<void> send() async {

    if (_from.isEmpty || _to.isEmpty || _subject.isEmpty || _content.isEmpty) {
      ErrorPopup.open(context);
      return;
    }

    DateTime start = DateTime.now();
    Popups.generic(
        context: context,
        height: 130,
        dismissible: false,
        body: Center(
          child: Text(t.mailMessageSend.sending, style: TextStyle(color: OvguColor.primary, fontSize: 20, fontWeight: FontWeight.bold)),
        )
    );


    final message = MailMessageSend(from: _from, to: _to, cc: _cc, subject: _subject, content: _content);
    bool result = await widget.client.sendMessage(message, name: widget.account.name, password: widget.account.password);

    // at least 1sec popup time
    int remainingTime = 1000 - DateTime.now().difference(start).inMilliseconds;
    if (remainingTime > 0)
      await sleep(remainingTime);
    Navigator.pop(context);

    if (result) {
      Navigator.pop(context);
    } else {
      ErrorPopup.open(context);
    }
  }

  void addCC() {
    setState(() {
      _cc = [ ..._cc, '' ];
    });
  }

  void removeCC() {
    setState(() {
      _cc.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
        title: Text(t.mailMessageSend.title),
      ),
      body: MainListView(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(15),
            child: OvguCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.mailMessageSend.from),
                    SizedBox(height: 5),
                    OvguTextField(
                        hint: t.mailMessageSend.from,
                        icon: Icons.person,
                        type: TextFieldType.CLEAR,
                        onChange: (value) {
                          setState(() {
                            _from = value;
                          });
                        }
                    ),
                    SizedBox(height: 15),
                    Text(t.mailMessageSend.to),
                    SizedBox(height: 5),
                    OvguTextField(
                        hint: t.mailMessageSend.to,
                        icon: Icons.person,
                        type: TextFieldType.CLEAR,
                        onChange: (value) {
                          setState(() {
                            _to = value;
                          });
                        }
                    ),
                    SizedBox(height: 15),
                    ...List.generate(_cc.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: OvguTextField(
                          hint: t.mailMessageSend.cc,
                          icon: Icons.people,
                          type: TextFieldType.CLEAR,
                          onChange: (value) {
                            setState(() {
                              _cc[index] = value;
                            });
                          }
                        ),
                      );
                    }),
                    Row(
                      children: [
                        OvguButton(
                            callback: addCC,
                            child: Icon(Icons.person_add, color: Colors.white)
                        ),
                        SizedBox(width: 15),
                        OvguButton(
                          callback: _cc.isNotEmpty ? removeCC : null,
                          child: Icon(Icons.person_remove, color: Colors.white)
                        )
                      ],
                    )
                  ],
                ),
              )
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: OvguTextField(
                hint: t.mailMessageSend.subject,
                icon: Icons.subject,
                type: TextFieldType.CLEAR,
                onChange: (value) {
                  setState(() {
                    _subject = value;
                  });
                }
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: OvguTextArea(
                hint: t.mailMessageSend.content,
                minLines: 10,
                maxLines: 20,
                onChange: (value) {
                  setState(() {
                    _content = value;
                  });
                }
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: Align(
              alignment: Alignment.centerRight,
              child: UnconstrainedBox(
                child: OvguButton(
                  callback: send,
                  child: Row(
                    children: [
                      Text(t.mailMessageSend.send, style: TextStyle(color: Colors.white)),
                      SizedBox(width: 10),
                      Icon(Icons.send, color: Colors.white)
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}
