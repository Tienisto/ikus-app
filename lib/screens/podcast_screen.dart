import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/podcast_file_card.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/podcast.dart';
import 'package:ikus_app/screens/image_screen.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class PodcastScreen extends StatefulWidget {

  final Podcast podcast;

  const PodcastScreen({@required this.podcast});

  @override
  _PodcastScreenState createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
        title: Text(t.podcast.title),
      ),
      body: MainListView(
        padding: OvguPixels.mainScreenPadding,
        children: [
          SizedBox(height: 30),
          Text(widget.podcast.name, style: TextStyle(fontSize: 24)),
          SizedBox(height: 30),
          InkWell(
            onTap: () {
              pushScreen(context, () => ImageScreen(image: Image.network(widget.podcast.image), tag: widget.podcast.id));
            },
            child: Hero(
              tag: widget.podcast.id,
              child: ClipRRect(
                borderRadius: OvguPixels.borderRadiusImage,
                child: Image.network(widget.podcast.image)
              )
            ),
          ),
          SizedBox(height: 30),
          ...widget.podcast.files.map((file) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: PodcastFileCard(file: file),
            );
          }),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
