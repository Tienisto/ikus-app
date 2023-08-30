import 'package:flutter/material.dart';
import 'package:ikus_app/components/badge.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';

class ImageScreen extends StatelessWidget {

  final Object tag;
  final String? title;
  final Image image;

  const ImageScreen({required this.tag, required this.image, this.title});

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
          if (title != null)
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: IkusBadge(text: title!),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: OvguButton(
                  color: Colors.white,
                  callback: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
