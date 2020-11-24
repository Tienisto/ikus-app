import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/inputs/ovgu_text_field.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/components/popups/error_popup.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/mail_facade.dart';
import 'package:ikus_app/utility/popups.dart';
import 'package:ikus_app/utility/ui.dart';

class OvguAccountScreen extends StatefulWidget {

  final SimpleWidgetBuilder afterLoginScreen;

  const OvguAccountScreen({this.afterLoginScreen});

  @override
  _OvguAccountScreenState createState() => _OvguAccountScreenState();
}

class _OvguAccountScreenState extends State<OvguAccountScreen> {

  String _accountName = SettingsService.instance.getOvguAccount()?.name;
  String _name = '';
  String _password = '';

  void saveCredentials() async {

    Popups.generic(
        context: context,
        height: 130,
        dismissible: false,
        body: Center(
          child: Text(t.ovguAccount.authenticating, style: TextStyle(color: OvguColor.primary, fontSize: 24, fontWeight: FontWeight.bold)),
        )
    );

    DateTime start = DateTime.now();
    bool success = await MailFacade.testLogin(name: _name, password: _password);
    await sleepRemaining(1000, start);
    Navigator.pop(context);

    if (success) {
      await SettingsService.instance.setOvguAccount(name: _name, password: _password);
      Navigator.pop(context);
      if (widget.afterLoginScreen != null) {
        pushScreen(context, widget.afterLoginScreen);
      }
    } else {
      ErrorPopup.open(context);
    }
  }

  void deleteCredentials() async {
    await SettingsService.instance.deleteOvguAccount();
    setState(() {
      _accountName = null;
      _name = '';
      _password = '';
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
        title: Text(t.ovguAccount.title)
      ),
      body: MainListView(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Image.asset('assets/img/logo-512-alpha.png', width: 150),
          SizedBox(height: 10),
          Center(
            child: Text(t.ovguAccount.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center)
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(t.ovguAccount.info, style: TextStyle(fontSize: 16), textAlign: TextAlign.center)
            ),
          ),
          SizedBox(height: 50),
          if (_accountName != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OvguCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(), // fill width
                      SizedBox(height: 20),
                      Text(t.ovguAccount.loggedInAs, style: TextStyle(fontSize: 20)),
                      SizedBox(height: 20),
                      Text(_accountName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 30),
                      OvguButton(
                        callback: deleteCredentials,
                        child: Text(t.ovguAccount.logout, style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          if (_accountName == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OvguCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.ovguAccount.loginCredentials, style: TextStyle(fontSize: 20)),
                      SizedBox(height: 20),
                      OvguTextField(
                          hint: t.ovguAccount.name,
                          icon: Icons.person,
                          onChange: (value) {
                            setState(() {
                              _name = value;
                            });
                          }
                      ),
                      SizedBox(height: 15),
                      OvguTextField(
                          hint: t.ovguAccount.password,
                          icon: Icons.vpn_key,
                          type: TextFieldType.PASSWORD,
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
                            callback: saveCredentials,
                            child: Text(t.ovguAccount.login, style: TextStyle(color: Colors.white)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
