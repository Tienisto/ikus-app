import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/audio_file_card.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/audio.dart';
import 'package:ikus_app/screens/image_screen.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class AudioScreen extends StatelessWidget {
  final Audio audio;

  const AudioScreen({required this.audio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.audio.title),
      ),
      body: MainListView(
        padding: OvguPixels.mainScreenPadding,
        children: [
          SizedBox(height: 30),
          Text(audio.name, style: TextStyle(fontSize: 24)),
          SizedBox(height: 30),
          if (audio.image != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: InkWell(
                onTap: () {
                  pushScreen(context, () => ImageScreen(image: Image.network(ApiService.getFileUrl(audio.image!)), tag: audio.id));
                },
                child: Hero(
                  tag: audio.id,
                  child: ClipRRect(
                    borderRadius: OvguPixels.borderRadiusImage,
                    child: Image.network(ApiService.getFileUrl(audio.image!)),
                  ),
                ),
              ),
            ),
          ...audio.files.map((file) {
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
