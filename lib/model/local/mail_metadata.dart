class MailMetadata {

  final DateTime? timestamp;
  final int countInbox;
  final int countSent;

  MailMetadata({required this.timestamp, required this.countInbox, required this.countSent});
}