import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/info_text.dart';
import 'package:ikus_app/components/inputs/ovgu_text_field.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/components/popups/error_popup.dart';
import 'package:ikus_app/components/popups/generic_text_popup.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/service/mail_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/mail_facade.dart';
import 'package:ikus_app/utility/ui.dart';

class OvguAccountScreen extends StatefulWidget {

  final Callback? onLogin;

  const OvguAccountScreen({this.onLogin});

  @override
  _OvguAccountScreenState createState() => _OvguAccountScreenState();
}

class _OvguAccountScreenState extends State<OvguAccountScreen> {

  String? _accountName = SettingsService.instance.getOvguAccount()?.name;
  String _name = '';
  String _password = '';
  bool loggingOut = false;

  void login() async {

    GenericTextPopup.open(context: context, text: t.ovguAccount.authenticating);

    bool success = await MailFacade.testLogin(name: _name, password: _password);

    if (success) {
      await SettingsService.instance.setOvguAccount(name: _name, password: _password);
      MailService.instance.sync(useNetwork: true);
      Navigator.pop(context);
      Navigator.pop(context);
      if (widget.onLogin != null) {
        widget.onLogin!();
      }
    } else {
      Navigator.pop(context);
      ErrorPopup.open(context);
    }
  }

  void logout() async {
    if (loggingOut)
      return;

    loggingOut = true;

    await SettingsService.instance.deleteOvguAccount();
    await MailService.instance.deleteCache();
    setState(() {
      _accountName = null;
      _name = '';
      _password = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.ovguAccount.title)
      ),
      body: MainListView(
        padding: OvguPixels.mainScreenPadding,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Image.asset('assets/img/logo-512-alpha.png', width: 150),
          SizedBox(height: 10),
          Center(
            child: Text(t.ovguAccount.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center)
          ),
          SizedBox(height: 20),
          Center(
            child: Text(t.ovguAccount.info, style: TextStyle(fontSize: 16), textAlign: TextAlign.center)
          ),
          SizedBox(height: 50),
          if (_accountName != null)
            OvguCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(), // fill width
                    SizedBox(height: 20),
                    Text(t.ovguAccount.loggedInAs, style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    Text(_accountName!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 30),
                    OvguButton(
                      callback: logout,
                      child: Text(t.ovguAccount.logout, style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          if (_accountName == null)
            OvguCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.ovguAccount.loginCredentials, style: TextStyle(fontSize: 20)),
                      SizedBox(height: 20),
                      OvguTextField(
                        hint: t.ovguAccount.name,
                        autofillHints: ['name', 'username'],
                        icon: Icons.person,
                        onEditingComplete: () => node.nextFocus(),
                        onChange: (value) {
                          setState(() {
                            _name = value;
                          });
                        }
                      ),
                      SizedBox(height: 15),
                      OvguTextField(
                        hint: t.ovguAccount.password,
                        autofillHints: ['password'],
                        icon: Icons.vpn_key,
                        type: TextFieldType.PASSWORD,
                        onSubmitted: (value) {
                          node.unfocus();
                          setState(() {
                            _password = value;
                          });
                          login();
                        },
                        onChange: (value) {
                          setState(() {
                            _password = value;
                          });
                        }
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          OvguButton(
                            callback: login,
                            child: Text(t.ovguAccount.login, style: TextStyle(color: Colors.white)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          SizedBox(height: 20),
          InfoText(t.ovguAccount.privacy),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
