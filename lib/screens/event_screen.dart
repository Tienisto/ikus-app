import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/components/marker_symbol.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/ui.dart';
import 'package:maps_launcher/maps_launcher.dart';

class EventScreen extends StatelessWidget {

  static final TextStyle keyStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static final double valueSize = 20;

  final Event event;

  const EventScreen(this.event);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
        title: Text(t.event.title),
      ),
      body: ListView(
        physics: Adaptive.getScrollPhysics(),
        padding: OvguPixels.mainScreenPadding,
        children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(event.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 40),
          Card(
            color: OvguColor.secondary,
            shape: OvguPixels.shape,
            elevation: OvguPixels.elevation,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.event.when, style: keyStyle),
                  SizedBox(height: 10),
                  IconText(
                    size: valueSize,
                    icon: Icons.event,
                    text: event.formattedDateWithWeekday,
                  ),
                  if(event.hasTime)
                    SizedBox(height: 10),
                  if(event.hasTime)
                    IconText(
                      size: valueSize,
                      icon: Icons.access_time,
                      text: event.formattedTime,
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 40),
          Card(
            color: OvguColor.secondary,
            shape: OvguPixels.shape,
            elevation: OvguPixels.elevation,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.event.where, style: keyStyle),
                  SizedBox(height: 10),
                  IconText(
                    size: valueSize,
                    icon: Icons.place,
                    text: event.place,
                  ),
                  if (event.coords != null)
                    SizedBox(height: 15),
                  if (event.coords != null)
                    SizedBox(
                      height: 250,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: OvguColor.secondaryDarken1,
                                borderRadius: OvguPixels.borderRadius
                            ),
                            padding: const EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: OvguPixels.borderRadius,
                              child: FlutterMap(
                                options: MapOptions(
                                    center: event.coords,
                                    zoom: 15
                                ),
                                layers: [
                                  TileLayerOptions(
                                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                      subdomains: ['a', 'b', 'c']
                                  ),
                                  MarkerLayerOptions(
                                    markers: [
                                      Marker(
                                        width: MarkerSymbol.width,
                                        height: MarkerSymbol.height,
                                        point: event.coords,
                                        builder: (ctx) => MarkerSymbol(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 2,
                            child: RaisedButton(
                              color: OvguColor.primary,
                              shape: OvguPixels.shape,
                              elevation: OvguPixels.elevation,
                              onPressed: () {
                                MapsLauncher.launchCoordinates(event.coords.latitude, event.coords.longitude);
                              },
                              child: Text(t.event.openApp, style: TextStyle(color: Colors.white)),
                            ),
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
