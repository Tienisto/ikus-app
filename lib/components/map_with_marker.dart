import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/marker_symbol.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/coords.dart' as model;
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';
import 'package:latlong2/latlong.dart';

/// displays a map showing the marker
/// also has a navigation button
class MapWithMarker extends StatelessWidget {
  final String? name;
  final model.Coords coords;

  const MapWithMarker({required this.name, required this.coords});

  @override
  Widget build(BuildContext context) {
    final position = LatLng(coords.x, coords.y);
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: OvguColor.secondaryDarken1,
              borderRadius: OvguPixels.borderRadius,
            ),
            padding: const EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: OvguPixels.borderRadius,
              child: FlutterMap(
                options: MapOptions(
                  center: position,
                  zoom: 14.5,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: MarkerSymbol.width,
                        height: MarkerSymbol.height,
                        point: position,
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
          ),
        ],
      ),
    );
  }
}
