import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/model/post.dart';
import 'package:ikus_app/utility/callbacks.dart';

class FAQResultItem extends StatelessWidget {

  final Post post;
  final Callback callback;

  const FAQResultItem({required this.post, required this.callback});

  @override
  Widget build(BuildContext context) {
    return OvguButton(
      callback: callback,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(), // stretch width
          SizedBox(height: 10),
          Text(post.channel.name + ':', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(post.title, style: TextStyle(color: Colors.white)),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
