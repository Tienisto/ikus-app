import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ikus_app/components/marker_symbol.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/utility/ui.dart';
import "package:latlong/latlong.dart";
import 'package:map_launcher/map_launcher.dart' as map_launcher;

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
            bottom: 2,
            child: RaisedButton(
              color: OvguColor.primary,
              shape: OvguPixels.shape,
              elevation: OvguPixels.elevation,
              onPressed: () async {
                List<map_launcher.AvailableMap> availableMaps = await map_launcher.MapLauncher.installedMaps;
                map_launcher.AvailableMap app = availableMaps.firstWhere((a) => a.mapType == map_launcher.MapType.google, orElse: () => availableMaps.first);
                await app.showMarker(coords: map_launcher.Coords(coords.latitude, coords.longitude), title: name);
              },
              child: Text(t.components.mapWithMarker.openMapApp, style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
