import 'package:flutter/material.dart';
import 'package:ikus_app/model/post.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class PostCard extends StatelessWidget {

  final Post post;
  final Callback callback;

  const PostCard({@required this.post, @required this.callback});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: OvguPixels.elevation,
      color: OvguColor.secondary,
      shape: OvguPixels.shape,
      child: InkWell(
        customBorder: OvguPixels.shape,
        onTap: callback,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: OvguColor.primary,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(OvguPixels.borderRadiusPlain), bottomRight: Radius.circular(OvguPixels.borderRadiusPlain))
                  ),
                  child: Text(post.group, style: TextStyle(color: Colors.white))
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 10),
                  child: Text(Post.dateFormatter.format(post.date), style: TextStyle(color: OvguColor.secondaryDarken)),
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
                        child: post.images.first
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
