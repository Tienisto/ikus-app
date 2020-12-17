import 'package:flutter/material.dart';
import 'package:ikus_app/components/popups/generic_info_popup.dart';
import 'package:ikus_app/model/podcast_file.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/popups.dart';

class PodcastTextPopup extends StatelessWidget {

  final PodcastFile file;

  const PodcastTextPopup(this.file);

  static void open({@required BuildContext context, @required PodcastFile file}) {
    final height = MediaQuery.of(context).size.height;
    Popups.generic(
        context: context,
        height: height - 200,
        body: PodcastTextPopup(file)
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericInfoPopup(
        title: file.name,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
          child: ListView(
            physics: Adaptive.getScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              Text(file.text),
              SizedBox(height: 30),
            ],
          ),
        )
    );
  }
}
