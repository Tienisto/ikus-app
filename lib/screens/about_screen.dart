import 'package:flutter/material.dart';
import 'package:ikus_app/components/html_view.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/utility/ui.dart';

class AboutScreen extends StatelessWidget {

  static const TextStyle FONT = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text(t.about.title)
      ),
      body: MainListView(
        children: [
          SizedBox(height: 20),
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
            child: Text(t.about.idea.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ...t.about.idea.people.map((person) => Padding(
            padding: OvguPixels.mainScreenPadding,
            child: Text(person, style: FONT),
          )),
          SizedBox(height: 20),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: Text(t.about.technicalImplementation.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ...t.about.technicalImplementation.people.map((p) {
            return HtmlView(
              padding: OvguPixels.mainScreenPadding,
              html: p
            );
          }),
          SizedBox(height: 10),
          HtmlView(
            padding: OvguPixels.mainScreenPadding,
            html: t.about.contribute
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}
