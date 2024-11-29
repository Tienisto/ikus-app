import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/utility/mail_facade.dart';

enum MailboxType {
  INBOX, SENT
}

extension MailboxTypeExtensions on MailboxType {
  String get name {
    switch (this) {
      case MailboxType.INBOX:
        return t.mails.inbox;
      case MailboxType.SENT:
        return t.mails.sent;
    }
  }

  String get path {
    switch (this) {
      case MailboxType.INBOX:
        return MailFacade.MAILBOX_PATH_INBOX;
      case MailboxType.SENT:
        return MailFacade.MAILBOX_PATH_SEND;
    }
  }
}