import 'package:flutter/material.dart';
import 'package:ikus_app/components/badge.dart';
import 'package:ikus_app/components/html_view.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/post.dart';
import 'package:ikus_app/screens/image_screen.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';
import 'package:uuid/uuid.dart';

class PostScreen extends StatelessWidget {
  final Post post;

  const PostScreen(this.post);

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.post.title),
      ),
      body: MainListView(
        children: [
          SizedBox(height: 30),
          FittedBox(
            child: Row(
              children: [
                SizedBox(width: 20),
                Center(child: IkusBadge(text: post.channel.name)),
                SizedBox(width: 10),
                Center(child: IkusBadge(text: post.formattedDate)),
                SizedBox(width: 20),
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(post.title, style: TextStyle(fontSize: OvguPixels.headerSize, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: 30),
          HtmlView(
            padding: OvguPixels.mainScreenPadding,
            html: post.content,
          ),
          SizedBox(height: 30),
          if (post.images.length == 1)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                child: InkWell(
                  onTap: () {
                    pushScreen(context, () => ImageScreen(image: Image.network(ApiService.getFileUrl(post.images.first)), tag: 'postImage'));
                  },
                  child: ClipRRect(
                    borderRadius: OvguPixels.borderRadiusImage,
                    child: Hero(
                      tag: 'postImage',
                      child: Image.network(ApiService.getFileUrl(post.images.first)),
                    ),
                  ),
                ),
              ),
            ),
          if (post.images.length > 1)
            SizedBox(
              height: 400,
              child: ListView(
                physics: Adaptive.getScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: post.images.map((image) {
                  String tag = Uuid().v4();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: InkWell(
                        onTap: () {
                          pushScreen(context, () => ImageScreen(image: Image.network(ApiService.getFileUrl(image)), tag: tag));
                        },
                        child: ClipRRect(
                          borderRadius: OvguPixels.borderRadiusImage,
                          child: Hero(
                            tag: tag,
                            child: Image.network(ApiService.getFileUrl(image), width: displayWidth * 0.7, fit: BoxFit.fitWidth),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
