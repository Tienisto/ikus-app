import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
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
    return OvguCard(
      child: InkWell(
        customBorder: OvguPixels.shape,
        onTap: callback,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      height: 25,
                      decoration: BoxDecoration(
                        color: OvguColor.primary,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(OvguPixels.borderRadiusPlain), bottomRight: Radius.circular(OvguPixels.borderRadiusPlain))
                      ),
                      child: FittedBox(
                        // FittedBox scales the text down if it is too large
                        child: Text(post.channel.name, style: TextStyle(color: Colors.white))
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 5, right: 10),
                  child: Text(post.formattedDate, style: TextStyle(color: OvguColor.secondaryDarken2)),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.images.isNotEmpty)
                    ClipRRect(
                        borderRadius: OvguPixels.borderRadiusImage,
                        child: Image.network(ApiService.getFileUrl(post.images.first))
                    ),
                  if (post.images.isNotEmpty)
                    SizedBox(height: 15),
                  Text(post.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(post.preview),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
