import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/popups/podcast_text_popup.dart';
import 'package:ikus_app/model/podcast_file.dart';
import 'package:ikus_app/utility/ui.dart';

class PodcastFileCard extends StatefulWidget {

  final PodcastFile file;

  const PodcastFileCard({@required this.file});

  @override
  _PodcastFileCardState createState() => _PodcastFileCardState();
}

class _PodcastFileCardState extends State<PodcastFileCard> {

  double _currTime = 0;
  bool _playing = false;

  @override
  Widget build(BuildContext context) {
    return OvguCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(widget.file.name, style: TextStyle(fontSize: 16)),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Slider(
              value: _currTime,
              activeColor: OvguColor.primary,
              inactiveColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _currTime = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text('0:00 / 3:12')
                ),
                if (widget.file.text != null)
                  OvguButton(
                    flat: true,
                    callback: () {
                      PodcastTextPopup.open(context: context, file: widget.file);
                    },
                    child: Icon(Icons.notes)
                  ),
                OvguButton(
                  flat: true,
                  callback: () {
                    setState(() {
                      _playing = !_playing;
                    });
                  },
                  child: Icon(_playing ? Icons.pause : Icons.play_arrow)
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
