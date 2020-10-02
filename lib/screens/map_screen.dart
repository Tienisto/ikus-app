import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/map_preview_card.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/screens/map_view_screen.dart';
import 'package:ikus_app/service/orientation_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final Image campusMain = Image.asset('assets/img/maps/campus-main.jpg');
    final Image campusMed = Image.asset('assets/img/maps/campus-med.jpg');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
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
            image: campusMain,
            callback: () {
              pushScreen(context, () => MapViewScreen(image: campusMain, controls: MapControlsPosition.LEFT, tag: ''), ScreenOrientation.LANDSCAPE);
            },
          ),
          SizedBox(height: 30),
          IconText(
              size: OvguPixels.headerSize,
              text: t.map.med,
              icon: Icons.local_hospital
          ),
          SizedBox(height: 10),
          Hero(
            tag: "campusMed",
            child: MapPreviewCard(
              image: campusMed,
              callback: () {
                pushScreen(context, () => MapViewScreen(image: campusMed, controls: MapControlsPosition.TOP, tag: "campusMed"));
              },
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
