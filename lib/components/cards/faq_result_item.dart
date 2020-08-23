import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/model/post.dart';
import 'package:ikus_app/utility/callbacks.dart';

class FAQResultItem extends StatelessWidget {

  final Post post;
  final Callback callback;

  const FAQResultItem({@required this.post, @required this.callback});

  @override
  Widget build(BuildContext context) {
    return OvguButton(
      callback: callback,
      child: Row(
        children: [
          Text(post.channel.name + ':', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(width: 10),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(post.title, style: TextStyle(color: Colors.white)),
              )
          ),
        ],
      ),
    );
  }
}
