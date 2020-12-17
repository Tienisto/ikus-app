import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/ovgu_network_image.dart';
import 'package:ikus_app/model/podcast.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class PodcastCard extends StatelessWidget {

  final Podcast podcast;
  final Callback onTap;

  const PodcastCard({@required this.podcast, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OvguCard(
      child: InkWell(
        customBorder: OvguPixels.shape,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OvguNetworkImage(url: podcast.image, height: 200),
              SizedBox(height: 10),
              Text(podcast.name, style: TextStyle(fontSize: 20))
            ],
          ),
        ),
      ),
    );
  }
}
