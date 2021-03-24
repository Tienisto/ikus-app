import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/ovgu_network_image.dart';
import 'package:ikus_app/model/audio.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class AudioCard extends StatelessWidget {

  final Audio audio;
  final Callback onTap;

  const AudioCard({required this.audio, required this.onTap});

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
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: OvguNetworkImage(url: audio.image != null ? ApiService.getFileUrl(audio.image!) : null, height: 200),
              ),
              Text(audio.name, style: TextStyle(fontSize: 20))
            ],
          ),
        ),
      ),
    );
  }
}
