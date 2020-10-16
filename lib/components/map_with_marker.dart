import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/marker_symbol.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';
import "package:latlong/latlong.dart";

/// displays a map showing the marker
/// also has a navigation button
class MapWithMarker extends StatelessWidget {

  final String name;
  final LatLng coords;

  const MapWithMarker({@required this.name, @required this.coords});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                    center: coords,
                    zoom: 14.5
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
                        point: coords,
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
            bottom: 8,
            child: OvguButton(
              callback: () async {
                await openMap(coords, name);
              },
              child: Text(t.components.mapWithMarker.openMapApp, style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
