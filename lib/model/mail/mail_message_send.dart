import 'package:enough_mail/enough_mail.dart';

class MailMessageSend {

  final String from;
  final String to;
  final List<String> cc;
  final String subject;
  final String content;

  MailMessageSend({required this.from, required this.to, required this.cc, required this.subject, required this.content});

  MimeMessage toMimeMessage() {
    final builder = MessageBuilder.prepareMultipartAlternativeMessage();
    builder.from = [MailAddress(null, from)];
    builder.to = [MailAddress(null, to)];
    builder.cc = cc.map((c) => MailAddress(null, c)).toList();
    builder.subject = subject;
    builder.addTextPlain(content);
    return builder.buildMimeMessage();
  }
}