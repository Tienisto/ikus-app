import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/ui.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
        title: Text(t.contact.title)
      ),
      body: ListView(
        physics: Adaptive.getScrollPhysics(),
        children: [
          SizedBox(height: 50)
        ],
      ),
    );
  }
}