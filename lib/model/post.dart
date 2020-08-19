import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Post {

  static DateFormat _dateFormatter = DateFormat("dd.MM.yyyy");

  final String title;
  final String preview;
  final String content;
  final String group;
  final DateTime date;
  final List<Image> images;

  const Post(this.title, this.preview, this.content, this.group, this.date, this.images);

  String get formattedDate {
    return _dateFormatter.format(date);
  }
}