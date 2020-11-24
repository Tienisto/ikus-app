import 'package:flutter/material.dart';

class MailMessageSend {

  final String from;
  final String to;
  final List<String> cc;
  final String subject;
  final String content;

  MailMessageSend({@required this.from, @required this.to, @required this.cc, @required this.subject, @required this.content});
}