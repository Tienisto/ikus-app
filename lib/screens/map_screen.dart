import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/map_preview_card.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/screens/image_screen.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final Image campusMain = Image.asset('assets/img/maps/campus-main.jpg');
    final Image campusMed = Image.asset('assets/img/maps/campus-med.jpg');

    return Scaffold(
      appBar: AppBar(
        title: Text(t.map.title),
      ),
      body: MainListView(
        padding: OvguPixels.mainScreenPadding,
        children: [
          SizedBox(height: 30),
          IconText(
            size: OvguPixels.headerSize,
            text: t.map.main,
            icon: Icons.flag
          ),
          SizedBox(height: 10),
          MapPreviewCard(
            tag: 'campusMain',
            image: campusMain,
            callback: () {
              pushScreen(context, () => ImageScreen(image: campusMain, tag: 'campusMain', title: t.map.main));
            },
          ),
          SizedBox(height: 30),
          IconText(
              size: OvguPixels.headerSize,
              text: t.map.med,
              icon: Icons.local_hospital
          ),
          SizedBox(height: 10),
          MapPreviewCard(
            tag: 'campusMed',
            image: campusMed,
            callback: () {
              pushScreen(context, () => ImageScreen(image: campusMed, tag: 'campusMed', title: t.map.med));
            },
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
