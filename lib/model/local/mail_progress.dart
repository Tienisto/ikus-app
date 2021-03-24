import 'package:ikus_app/model/mail/mailbox_type.dart';

class MailProgress {
  bool active;
  MailboxType mailbox;
  int curr; // amount of mails already fetched (current mailbox)
  int total; // total amount of mails fetching (current mailbox)
  double percent; // total progress (all mailboxes)

  MailProgress({this.active = false, this.mailbox = MailboxType.INBOX, this.curr = 0, this.total = 0, this.percent = 0});

  void reset({bool starting = false}) {
    active = starting;
    mailbox = MailboxType.INBOX;
    curr = 0;
    total = 0;
    percent = 0;
  }
}