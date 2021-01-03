import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/audio_file_card.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/audio.dart';
import 'package:ikus_app/screens/image_screen.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class AudioScreen extends StatefulWidget {

  final Audio audio;

  const AudioScreen({@required this.audio});

  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
        title: Text(t.audio.title),
      ),
      body: MainListView(
        padding: OvguPixels.mainScreenPadding,
        children: [
          SizedBox(height: 30),
          Text(widget.audio.name, style: TextStyle(fontSize: 24)),
          SizedBox(height: 30),
          InkWell(
            onTap: () {
              pushScreen(context, () => ImageScreen(image: Image.network(widget.audio.image), tag: widget.audio.id));
            },
            child: Hero(
              tag: widget.audio.id,
              child: ClipRRect(
                borderRadius: OvguPixels.borderRadiusImage,
                child: Image.network(widget.audio.image)
              )
            ),
          ),
          SizedBox(height: 30),
          ...widget.audio.files.map((file) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: AudioFileCard(file: file),
            );
          }),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
