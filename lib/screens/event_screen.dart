import 'package:add_2_calendar/add_2_calendar.dart' as calendar;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/components/marker_symbol.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/ui.dart';
import 'package:map_launcher/map_launcher.dart' as map_launcher;

class EventScreen extends StatelessWidget {

  static final TextStyle keyStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static final double valueSize = 20;
  static final double buttonWidth = 60;

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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.event.when, style: keyStyle),
                        SizedBox(height: 10),
                        IconText(
                          size: valueSize,
                          icon: Icons.event,
                          text: event.formattedStartDateWithWeekday,
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
                  SizedBox(
                    width: buttonWidth,
                    child: RaisedButton(
                      color: OvguColor.primary,
                      shape: OvguPixels.shape,
                      elevation: OvguPixels.elevation,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // remove margin
                      onPressed: () {
                        calendar.Add2Calendar.addEvent2Cal(calendar.Event(
                            title: event.name,
                            location: event.place,
                            startDate: event.start,
                            endDate: event.hasEndTime ? event.end : event.hasTime ? event.start.add(Duration(hours: 10)) : event.start,
                            allDay: !event.hasTime
                        ));
                      },
                      child: Icon(Icons.add_alert, color: Colors.white),
                    ),
                  )
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
                              onPressed: () async {
                                List<map_launcher.AvailableMap> availableMaps = await map_launcher.MapLauncher.installedMaps;
                                map_launcher.AvailableMap app = availableMaps.firstWhere((a) => a.mapType == map_launcher.MapType.google, orElse: () => availableMaps.first);
                                await app.showMarker(coords: map_launcher.Coords(event.coords.latitude, event.coords.longitude), title: event.place);
                              },
                              child: Text(t.event.openMapApp, style: TextStyle(color: Colors.white)),
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
