import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card_with_header.dart';
import 'package:ikus_app/model/post.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class PostCard extends StatelessWidget {

  final Post post;
  final Callback callback;

  const PostCard({@required this.post, @required this.callback});

  @override
  Widget build(BuildContext context) {
    return OvguCardWithHeader(
      onTap: callback,
      left: post.channel.name,
      headerIcons: [
        if (post.pinned)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(Icons.push_pin, size: 16, color: OvguColor.secondaryDarken2),
          )
      ],
      right: post.formattedDate,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.images.isNotEmpty)
              SizedBox(
                height: 180,
                child: ClipRRect(
                  borderRadius: OvguPixels.borderRadiusImage,
                  child: Image.network(ApiService.getFileUrl(post.images.first),
                    width: 2000, // always use full width
                    fit: BoxFit.cover,
                    frameBuilder: (context, child, frame, _) {
                      if (frame == null) {
                        // fallback to placeholder
                        return Container(
                          color: OvguColor.secondaryDarken1,
                          child: Center(
                            child: Opacity(
                              opacity: 0.1,
                              child: Image.asset('assets/img/logo-512-alpha.png', height: 150)
                            )
                          )
                        );
                      }
                      return child;
                    }
                  )
                ),
              ),
            if (post.images.isNotEmpty)
              SizedBox(height: 15),
            Text(post.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(post.preview),
          ],
        ),
      )
    );
  }
}
