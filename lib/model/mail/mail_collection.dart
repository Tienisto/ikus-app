import 'package:ikus_app/model/mail/mail_message.dart';

class MailCollection {

  static const EMPTY = MailCollection(inbox: {}, sent: {});

  // using maps to achieve O(1) during mail fetch
  // uid -> mail
  final Map<int, MailMessage> inbox;
  final Map<int, MailMessage> sent;

  const MailCollection({required this.inbox, required this.sent});
}