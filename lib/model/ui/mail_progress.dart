import 'package:ikus_app/model/mailbox_type.dart';

class MailProgress {
  bool active;
  MailboxType mailbox;
  int curr; // amount of mails already fetched (current mailbox)
  int total; // total amount of mails fetching (current mailbox)
  double percent; // total progress (all mailboxes)

  MailProgress({this.active = false, this.mailbox, this.curr, this.total, this.percent});
}