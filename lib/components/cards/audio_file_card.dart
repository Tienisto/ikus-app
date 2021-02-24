import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/ovgu_network_image.dart';
import 'package:ikus_app/components/popups/audio_text_popup.dart';
import 'package:ikus_app/components/rotating.dart';
import 'package:ikus_app/model/audio_file.dart';
import 'package:ikus_app/screens/image_screen.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class AudioFileCard extends StatefulWidget {

  final AudioFile file;

  const AudioFileCard({@required this.file});

  @override
  _AudioFileCardState createState() => _AudioFileCardState();
}

class _AudioFileCardState extends State<AudioFileCard> {

  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayerState _playerState = AudioPlayerState.STOPPED;
  bool _loading = false;
  double _targetTime; // in sec, not null during dragging
  double _currTime = 0; // in sec
  double _duration; // in sec

  Future<void> play({position}) async {
    if (_loading)
      return;

    // lock
    _loading = true;
    setState(() {});

    await audioPlayer.play(ApiService.getFileUrl(widget.file.file), isLocal: false, position: position);
    audioPlayer.onDurationChanged.listen((Duration d) {
      if (mounted)
        setState(() => _duration = d.inMilliseconds / 1000);
    });
    audioPlayer.onAudioPositionChanged.listen((Duration d) {
      if (mounted)
        setState(() {
          _currTime = d.inMilliseconds / 1000;
          _loading = false; // release lock
        });
    });
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted)
        setState(() => _playerState = state);
    });

    _playerState = AudioPlayerState.PLAYING;
  }

  Future<void> stop() async {
    await audioPlayer.pause();
  }

  String secondsToString(double sec) {
    int minutes = sec ~/ 60;
    int seconds = sec.floor() % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OvguCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          if (widget.file.image != null)
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: InkWell(
                onTap: () {
                  pushScreen(context, () => ImageScreen(image: Image.network(ApiService.getFileUrl(widget.file.image)), tag: 'audioFile-${widget.file.id}'));
                },
                child: OvguNetworkImage(
                  url: ApiService.getFileUrl(widget.file.image),
                  height: 150,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(widget.file.name, style: TextStyle(fontSize: 16)),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Slider(
              value: (_targetTime ?? _currTime) / (_duration ?? 1),
              activeColor: OvguColor.primary,
              inactiveColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  if (_duration == null)
                    return;
                  _targetTime = value * _duration;
                });
              },
              onChangeStart: (value) {
                setState(() {
                  if (_duration == null)
                    return;
                  _targetTime = value * _duration;
                });
              },
              onChangeEnd: (value) {
                setState(() {
                  if (_duration == null)
                    return;

                  final position = Duration(seconds: (value * _duration).floor());
                  if (_playerState == AudioPlayerState.COMPLETED)
                    play(position: position);
                  else
                    audioPlayer.seek(position);

                  _targetTime = null;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(_duration != null ? '${secondsToString(_targetTime ?? _currTime)} / ${secondsToString(_duration)}' : '')
                ),
                if (widget.file.text != null)
                  OvguButton(
                    flat: true,
                    callback: () {
                      AudioTextPopup.open(context: context, file: widget.file);
                    },
                    child: Icon(Icons.notes)
                  ),
                OvguButton(
                  flat: true,
                  callback: () {
                    if (_loading)
                      return;

                    if (_playerState == AudioPlayerState.PLAYING) {
                      stop();
                    } else {
                      play();
                    }
                  },
                  child: _loading ? Rotating(child: Icon(Icons.sync)) : Icon(_playerState == AudioPlayerState.PLAYING ? Icons.pause : Icons.play_arrow)
                )
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      )
    );
  }
}
