import 'package:flutter/material.dart';

class Post {

  final String title;
  final String preview;
  final String group;
  final String date;
  final Image image;

  const Post(this.title, this.preview, this.group, this.date, this.image);
}