import 'package:flutter/material.dart';
import 'package:ikus_app/utility/ui.dart';

enum MapControlsPosition {
  LEFT,
  TOP
}

class MapViewScreen extends StatefulWidget {

  final Image image;
  final MapControlsPosition controls;

  const MapViewScreen({@required this.image, @required this.controls});

  @override
  _MapViewScreenState createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {

  Widget _getControls() {
    return RaisedButton(
      color: OvguColor.primary,
      shape: OvguPixels.shape,
      onPressed: () {
        Navigator.pop(context);
      },
      child: Icon(Icons.arrow_back, color: Colors.white),
    );
  }

  Widget _getMapView() {
    return Expanded(
      child: InteractiveViewer (
        minScale: 1,
        maxScale: 5,
        child: widget.image,
      ),
    );
  }

  Widget _getContent() {
    if (widget.controls == MapControlsPosition.LEFT)
      return Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: _getControls(),
          ),
          _getMapView()
        ],
      );
    else
      return Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: _getControls(),
          ),
          _getMapView()
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: _getContent()
      ),
    );
  }
}
