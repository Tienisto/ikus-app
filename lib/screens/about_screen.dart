import 'package:flutter/material.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/utility/ui.dart';

class AboutScreen extends StatelessWidget {

  static const TextStyle FONT = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          backgroundColor: OvguColor.primary,
          title: Text(t.about.title)
      ),
      body: MainListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Center(
            child: Image.asset('assets/img/logo-512-alpha.png', width: 200),
          ),
          SizedBox(height: 20),
          Text(t.about.main, style: FONT),
          SizedBox(height: 20),
          Text(t.about.idea, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('Anne-Katrin Behnert', style: FONT),
          Text('Christin Scheil', style: FONT),
          Text('Ester Greco', style: FONT),
          Text('Eva Böhning', style: FONT),
          SizedBox(height: 20),
          Text(t.about.technicalImplementation, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('Tien Do Nam (August 2020 - heute)', style: FONT),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}
