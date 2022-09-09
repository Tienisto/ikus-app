import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/audio_file_card.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/audio.dart';
import 'package:ikus_app/screens/image_screen.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class AudioScreen extends StatefulWidget {

  final Audio audio;

  const AudioScreen({required this.audio});

  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {

  @override
  void initState() {
    super.initState();

    // https://github.com/bluefireteam/audioplayers/issues/1194
    final AudioContext audioContext = AudioContext(
      iOS: AudioContextIOS(
        defaultToSpeaker: true,
        category: AVAudioSessionCategory.ambient,
        options: [
          AVAudioSessionOptions.defaultToSpeaker,
          AVAudioSessionOptions.mixWithOthers,
        ],
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: true,
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.assistanceSonification,
        audioFocus: AndroidAudioFocus.none,
      ),
    );
    AudioPlayer.global.setGlobalAudioContext(audioContext);
  }

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
          Text(widget.audio.name, style: TextStyle(fontSize: 24)),
          SizedBox(height: 30),
          if (widget.audio.image != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: InkWell(
                onTap: () {
                  pushScreen(context, () => ImageScreen(image: Image.network(ApiService.getFileUrl(widget.audio.image!)), tag: widget.audio.id));
                },
                child: Hero(
                  tag: widget.audio.id,
                  child: ClipRRect(
                    borderRadius: OvguPixels.borderRadiusImage,
                    child: Image.network(ApiService.getFileUrl(widget.audio.image!))
                  )
                ),
              ),
            ),
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
