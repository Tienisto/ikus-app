import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';

class ImageScreen extends StatelessWidget {

  final String tag;
  final Image image;

  const ImageScreen({@required this.tag, @required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.black,
              child: Hero(
                tag: tag,
                child: InteractiveViewer (
                  minScale: 1,
                  maxScale: 5,
                  child: image,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: OvguButton(
                  color: Colors.white,
                  type: OvguButtonType.ICON_WIDE,
                  callback: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close, color: Colors.black),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
