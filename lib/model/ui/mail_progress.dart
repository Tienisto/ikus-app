class MailProgress {
  bool active;
  String mailbox;
  int curr;
  int total;

  MailProgress({this.active = false, this.mailbox, this.curr, this.total});
}