import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/utility/ui.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {

  static const TextStyle FONT = TextStyle(fontSize: 16);
  static const List<String> IDEA = [
    'Anne-Katrin Behnert',
    'Christin Scheil',
    'Ester Greco',
    'Eva Böhning'
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          backgroundColor: OvguColor.primary,
          title: Text(t.about.title)
      ),
      body: MainListView(
        children: [
          Center(
            child: Image.asset('assets/img/logo-512-alpha.png', width: 200),
          ),
          SizedBox(height: 20),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: Text(t.about.main, style: FONT),
          ),
          SizedBox(height: 20),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: Text(t.about.idea, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ...IDEA.map((person) => Padding(
            padding: OvguPixels.mainScreenPadding,
            child: Text(person, style: FONT),
          )),
          SizedBox(height: 20),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: Text(t.about.technicalImplementation, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: Text('Tien Do Nam (August 2020 - heute)', style: FONT),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Html(
              data: t.about.contribute,
              style: {
                "body": Style(fontSize: FontSize.large, padding: EdgeInsets.zero), // make text bigger
              },
              onLinkTap: (url) async {
                await launch(url);
              },
            ),
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}
