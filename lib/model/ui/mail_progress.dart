import 'package:ikus_app/model/mailbox_type.dart';

class MailProgress {
  bool active;
  MailboxType mailbox;
  int curr;
  int total;

  MailProgress({this.active = false, this.mailbox, this.curr, this.total});
}