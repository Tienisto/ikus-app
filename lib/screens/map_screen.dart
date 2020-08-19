import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/map_card.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/screens/map_view_screen.dart';
import 'package:ikus_app/service/orientation_service.dart';
import 'package:ikus_app/utility/adaptive.dart';
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
      body: ListView(
        physics: Adaptive.getScrollPhysics(),
        padding: OvguPixels.mainScreenPadding,
        children: [
          SizedBox(height: 30),
          IconText(
            size: OvguPixels.headerSize,
            text: t.map.main,
            icon: Icons.flag
          ),
          SizedBox(height: 10),
          MapCard(
            image: campusMain,
            callback: () {
              pushScreen(context, () => MapViewScreen(image: campusMain, controls: MapControlsPosition.LEFT), ScreenOrientation.LANDSCAPE);
            },
          ),
          SizedBox(height: 30),
          IconText(
              size: OvguPixels.headerSize,
              text: t.map.med,
              icon: Icons.local_hospital
          ),
          SizedBox(height: 10),
          MapCard(
            image: campusMed,
            callback: () {
              pushScreen(context, () => MapViewScreen(image: campusMed, controls: MapControlsPosition.TOP));
            },
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
