import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/utility/mail_facade.dart';

enum MailboxType {
  INBOX, SENT
}

extension MailboxTypeExtensions on MailboxType {
  String get name => {
    MailboxType.INBOX: t.mails.inbox,
    MailboxType.SENT: t.mails.sent
  }[this];

  String get path => {
    MailboxType.INBOX: MailFacade.MAILBOX_PATH_INBOX,
    MailboxType.SENT: MailFacade.MAILBOX_PATH_SEND
  }[this];
}