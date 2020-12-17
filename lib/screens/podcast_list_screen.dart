import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/podcast_card.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/podcast.dart';
import 'package:ikus_app/screens/podcast_screen.dart';
import 'package:ikus_app/service/podcast_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class PodcastListScreen extends StatefulWidget {

  @override
  _PodcastListScreenState createState() => _PodcastListScreenState();
}

class _PodcastListScreenState extends State<PodcastListScreen> {

  List<Podcast> podcasts;

  @override
  void initState() {
    super.initState();
    loadPodcasts();
  }

  Future<void> loadPodcasts() async {
    podcasts = await PodcastService.instance.getPodcasts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
        title: Text(t.podcast_list.title),
      ),
      body: MainListView(
        children: [
          SizedBox(height: 30),
          if (podcasts != null && podcasts.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Center(
                child: Container(
                  child: Text(t.podcast_list.empty, style: TextStyle(color: OvguColor.secondaryDarken2, fontSize: 20)),
                ),
              ),
            ),
          if (podcasts != null)
            ...podcasts.map((podcast) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
                child: PodcastCard(
                  podcast: podcast,
                  onTap: () {
                    pushScreen(context, () => PodcastScreen(podcast: podcast));
                  },
                ),
              );
            }),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
