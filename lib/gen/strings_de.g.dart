///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsDe implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsDe({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.de,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  );

	/// Metadata for the translations of <de>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsDe _root = this; // ignore: unused_field

	@override 
	TranslationsDe $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsDe(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsMetaDe meta = _TranslationsMetaDe._(_root);
	@override late final _TranslationsFeaturesDe features = _TranslationsFeaturesDe._(_root);
	@override late final _TranslationsWelcomeDe welcome = _TranslationsWelcomeDe._(_root);
	@override late final _TranslationsTutorialDe tutorial = _TranslationsTutorialDe._(_root);
	@override late final _TranslationsMainDe main = _TranslationsMainDe._(_root);
	@override late final _TranslationsAboutDe about = _TranslationsAboutDe._(_root);
	@override late final _TranslationsContactsDe contacts = _TranslationsContactsDe._(_root);
	@override late final _TranslationsEventDe event = _TranslationsEventDe._(_root);
	@override late final _TranslationsFaqDe faq = _TranslationsFaqDe._(_root);
	@override late final _TranslationsHandbookDe handbook = _TranslationsHandbookDe._(_root);
	@override late final _TranslationsLinksDe links = _TranslationsLinksDe._(_root);
	@override late final _TranslationsMailsDe mails = _TranslationsMailsDe._(_root);
	@override late final _TranslationsMailMessageDe mailMessage = _TranslationsMailMessageDe._(_root);
	@override late final _TranslationsMailMessageSendDe mailMessageSend = _TranslationsMailMessageSendDe._(_root);
	@override late final _TranslationsMapDe map = _TranslationsMapDe._(_root);
	@override late final _TranslationsMensaDe mensa = _TranslationsMensaDe._(_root);
	@override late final _TranslationsMyEventsDe myEvents = _TranslationsMyEventsDe._(_root);
	@override late final _TranslationsRegisterEventDe registerEvent = _TranslationsRegisterEventDe._(_root);
	@override late final _TranslationsOvguAccountDe ovguAccount = _TranslationsOvguAccountDe._(_root);
	@override late final _TranslationsAudioListDe audioList = _TranslationsAudioListDe._(_root);
	@override late final _TranslationsAudioDe audio = _TranslationsAudioDe._(_root);
	@override late final _TranslationsPostDe post = _TranslationsPostDe._(_root);
	@override late final _TranslationsSyncDe sync = _TranslationsSyncDe._(_root);
	@override late final _TranslationsDevDe dev = _TranslationsDevDe._(_root);
	@override late final _TranslationsChangeLanguageDe changeLanguage = _TranslationsChangeLanguageDe._(_root);
	@override late final _TranslationsComponentsDe components = _TranslationsComponentsDe._(_root);
	@override late final _TranslationsPopupsDe popups = _TranslationsPopupsDe._(_root);
	@override late final _TranslationsNotificationsDe notifications = _TranslationsNotificationsDe._(_root);
	@override String timeFormat({required Object time}) => '${time} Uhr';
}

// Path: meta
class _TranslationsMetaDe implements TranslationsMetaEn {
	_TranslationsMetaDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get appName => 'Welcome to OVGU';
}

// Path: features
class _TranslationsFeaturesDe implements TranslationsFeaturesEn {
	_TranslationsFeaturesDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsFeaturesMapDe map = _TranslationsFeaturesMapDe._(_root);
	@override late final _TranslationsFeaturesMyEventsDe myEvents = _TranslationsFeaturesMyEventsDe._(_root);
	@override late final _TranslationsFeaturesMensaDe mensa = _TranslationsFeaturesMensaDe._(_root);
	@override late final _TranslationsFeaturesLinksDe links = _TranslationsFeaturesLinksDe._(_root);
	@override late final _TranslationsFeaturesHandbookDe handbook = _TranslationsFeaturesHandbookDe._(_root);
	@override late final _TranslationsFeaturesAudioDe audio = _TranslationsFeaturesAudioDe._(_root);
	@override late final _TranslationsFeaturesFaqDe faq = _TranslationsFeaturesFaqDe._(_root);
	@override late final _TranslationsFeaturesContactsDe contacts = _TranslationsFeaturesContactsDe._(_root);
	@override late final _TranslationsFeaturesEmailsDe emails = _TranslationsFeaturesEmailsDe._(_root);
}

// Path: welcome
class _TranslationsWelcomeDe implements TranslationsWelcomeEn {
	_TranslationsWelcomeDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => _root.meta.appName;
	@override String get intro => 'Herzlich willkommen in unserer App! Hier erhältst du alle wichtigen Informationen über das Leben an der Uni Magdeburg gebündelt und übersichtlich an einem Ort.';
	@override String get selectLanguage => 'Sprache auswählen:';
	@override String get english => 'Englisch';
	@override String get german => 'Deutsch';
	@override String get start => 'App Starten';
	@override String get loading => 'Lade Daten...';
}

// Path: tutorial
class _TranslationsTutorialDe implements TranslationsTutorialEn {
	_TranslationsTutorialDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override List<String> get steps => [
		'Das ist der Startbildschirm.\nHier findest du die neuesten Nachrichten.',
		'Auf der 2. Seite gibt es den Kalender, damit du kein Event verpasst!',
		'Auf der 3. Seite ist eine Liste von allen Funktionen dieser App.',
		'Wenn du eine Funktion häufig benutzt, dann tippe rechts auf das Herz.',
		'Die Funktionen mit den Herzen erscheinen hier.',
		'Das wäre alles.\nJetzt viel Spaß mit der App! :)',
	];
	@override String get skip => 'Schließen';
	@override String get next => 'Weiter';
	@override String get done => 'Fertig';
}

// Path: main
class _TranslationsMainDe implements TranslationsMainEn {
	_TranslationsMainDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override List<String> get bottomBar => [
		'Home',
		'Kalender',
		'Funktionen',
		'Einst.',
	];
	@override late final _TranslationsMainHomeDe home = _TranslationsMainHomeDe._(_root);
	@override late final _TranslationsMainCalendarDe calendar = _TranslationsMainCalendarDe._(_root);
	@override late final _TranslationsMainFeaturesDe features = _TranslationsMainFeaturesDe._(_root);
	@override late final _TranslationsMainSettingsDe settings = _TranslationsMainSettingsDe._(_root);
}

// Path: about
class _TranslationsAboutDe implements TranslationsAboutEn {
	_TranslationsAboutDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Über die App';
	@override String get main => 'Die ${_root.meta.appName}-App ist eine Initiative des Akademischen Auslandsamtes der Otto-von-Guericke-Universität Magdeburg mit dem Ziel, die Digitalisierung an der Universität voranzutreiben und den Studienalltag - insbesondere für internationale Studierende - zu erleichtern.';
	@override late final _TranslationsAboutIdeaDe idea = _TranslationsAboutIdeaDe._(_root);
	@override late final _TranslationsAboutTechnicalImplementationDe technicalImplementation = _TranslationsAboutTechnicalImplementationDe._(_root);
	@override String get contribute => 'Die App ist open source.<br>Du kannst <a href="https://github.com/Tienisto/ikus-app">hier</a> den Quellcode anschauen.<br><a href="https://github.com/Tienisto/ikus-app/issues">Issues</a> oder <a href="https://github.com/Tienisto/ikus-app/pulls">Pull Requests</a> sind willkommen.';
}

// Path: contacts
class _TranslationsContactsDe implements TranslationsContactsEn {
	_TranslationsContactsDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Kontakte';
}

// Path: event
class _TranslationsEventDe implements TranslationsEventEn {
	_TranslationsEventDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Event';
	@override late final _TranslationsEventRegistrationDe registration = _TranslationsEventRegistrationDe._(_root);
	@override String get when => 'Wann?';
	@override String get to => 'bis';
	@override String get where => 'Wo?';
}

// Path: faq
class _TranslationsFaqDe implements TranslationsFaqEn {
	_TranslationsFaqDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Häufig gestellte Fragen';
	@override String get search => 'Frage suchen...';
	@override String get suggestions => 'Vorschläge';
	@override String get noResults => 'Keine Ergebnisse.';
}

// Path: handbook
class _TranslationsHandbookDe implements TranslationsHandbookEn {
	_TranslationsHandbookDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Handbuch';
	@override String get wip => 'Handbuch ist in Arbeit.';
}

// Path: links
class _TranslationsLinksDe implements TranslationsLinksEn {
	_TranslationsLinksDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Hilfreiche Links';
}

// Path: mails
class _TranslationsMailsDe implements TranslationsMailsEn {
	_TranslationsMailsDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'E-Mails';
	@override String get alpha => 'Immer noch in alpha. Es wird noch optimiert.';
	@override late final _TranslationsMailsActionsDe actions = _TranslationsMailsActionsDe._(_root);
	@override String get inbox => 'Posteingang';
	@override String get sent => 'Gesendet';
	@override String sync({required Object text}) => 'Synchronisieren: ${text}';
	@override String get deleting => 'Löschen...';
	@override String get replyPrefix => 'von ';
}

// Path: mailMessage
class _TranslationsMailMessageDe implements TranslationsMailMessageEn {
	_TranslationsMailMessageDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'E-Mail';
}

// Path: mailMessageSend
class _TranslationsMailMessageSendDe implements TranslationsMailMessageSendEn {
	_TranslationsMailMessageSendDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'E-Mail senden';
	@override String get from => 'Von';
	@override String get to => 'An';
	@override String get cc => 'CC';
	@override String get subject => 'Betreff';
	@override String get content => 'Inhalt';
	@override String get send => 'Senden';
	@override String get sending => 'E-Mail wird gesendet...';
	@override late final _TranslationsMailMessageSendErrorsDe errors = _TranslationsMailMessageSendErrorsDe._(_root);
}

// Path: map
class _TranslationsMapDe implements TranslationsMapEn {
	_TranslationsMapDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Campusplan';
	@override String get main => 'Hauptcampus';
	@override String get med => 'Medizin-Campus';
}

// Path: mensa
class _TranslationsMensaDe implements TranslationsMensaEn {
	_TranslationsMensaDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mensa';
	@override late final _TranslationsMensaLocationsDe locations = _TranslationsMensaLocationsDe._(_root);
	@override String lastUpdate({required Object timestamp}) => 'Stand: ${timestamp}';
	@override String today({required Object date}) => 'Heute, ${date}';
	@override String tomorrow({required Object date}) => 'Morgen, ${date}';
	@override String get noData => 'Keine Daten verfügbar...';
	@override late final _TranslationsMensaTagsDe tags = _TranslationsMensaTagsDe._(_root);
}

// Path: myEvents
class _TranslationsMyEventsDe implements TranslationsMyEventsEn {
	_TranslationsMyEventsDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Meine Events';
	@override String get info => 'Du kannst Events mit einem Herzchen versehen. Diese Events erscheinen hier und unter "Nächsten Events" auf der Startseite.';
}

// Path: registerEvent
class _TranslationsRegisterEventDe implements TranslationsRegisterEventEn {
	_TranslationsRegisterEventDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Event anmelden';
	@override String get matriculationNumber => 'Matrikel-Nr.';
	@override String get firstName => 'Vorname';
	@override String get lastName => 'Nachname';
	@override String get email => 'E-Mail';
	@override String get address => 'Adresse';
	@override String get country => 'Heimatland';
	@override String get register => 'Anmelden';
	@override String get registering => 'Anmelden...';
	@override String get disclaimer => 'Eine Weitergabe der Daten an Dritte findet nicht statt. Die Daten werden gelöscht, sobald sie für die Erreichung des Zweckes ihrer Erhebung nicht mehr erforderlich sind.';
	@override late final _TranslationsRegisterEventErrorsDe errors = _TranslationsRegisterEventErrorsDe._(_root);
}

// Path: ovguAccount
class _TranslationsOvguAccountDe implements TranslationsOvguAccountEn {
	_TranslationsOvguAccountDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'OVGU-Account';
	@override String get info => 'Du kannst auf deine E-Mails zugreifen, sobald du dich mit deinem OVGU-Account anmeldest.';
	@override String get loginCredentials => 'Login-Daten';
	@override String get name => 'Name';
	@override String get password => 'Passwort';
	@override String get login => 'Login';
	@override String get loggedInAs => 'Eingeloggt als';
	@override String get logout => 'Abmelden';
	@override String get privacy => 'Deine Login-Daten werden verschlüsselt und nur auf deinem Gerät gespeichert.';
	@override String get authenticating => 'Authentifizierung';
}

// Path: audioList
class _TranslationsAudioListDe implements TranslationsAudioListEn {
	_TranslationsAudioListDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Audio-Guides';
	@override String get empty => 'In Arbeit.';
}

// Path: audio
class _TranslationsAudioDe implements TranslationsAudioEn {
	_TranslationsAudioDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Audio-Guide';
}

// Path: post
class _TranslationsPostDe implements TranslationsPostEn {
	_TranslationsPostDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Beitrag';
}

// Path: sync
class _TranslationsSyncDe implements TranslationsSyncEn {
	_TranslationsSyncDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Synchronisation';
	@override String get info => 'Diese App lädt regelmäßig Daten vom Server herunter, damit du auf dem neusten Stand bleibst. Du kannst die App mit den lokal gespeicherten Daten offline verwenden.';
	@override late final _TranslationsSyncItemsDe items = _TranslationsSyncItemsDe._(_root);
}

// Path: dev
class _TranslationsDevDe implements TranslationsDevEn {
	_TranslationsDevDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Entwickler-Einstellungen';
}

// Path: changeLanguage
class _TranslationsChangeLanguageDe implements TranslationsChangeLanguageEn {
	_TranslationsChangeLanguageDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Deutsche Daten laden...';
}

// Path: components
class _TranslationsComponentsDe implements TranslationsComponentsEn {
	_TranslationsComponentsDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsComponentsEventCardDe eventCard = _TranslationsComponentsEventCardDe._(_root);
	@override late final _TranslationsComponentsMapWithMarkerDe mapWithMarker = _TranslationsComponentsMapWithMarkerDe._(_root);
}

// Path: popups
class _TranslationsPopupsDe implements TranslationsPopupsEn {
	_TranslationsPopupsDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsPopupsChannelDe channel = _TranslationsPopupsChannelDe._(_root);
	@override late final _TranslationsPopupsDateDe date = _TranslationsPopupsDateDe._(_root);
	@override late final _TranslationsPopupsErrorDe error = _TranslationsPopupsErrorDe._(_root);
	@override late final _TranslationsPopupsEventAddedDe eventAdded = _TranslationsPopupsEventAddedDe._(_root);
	@override late final _TranslationsPopupsEventPastDe eventPast = _TranslationsPopupsEventPastDe._(_root);
	@override late final _TranslationsPopupsEventUnregisterDe eventUnregister = _TranslationsPopupsEventUnregisterDe._(_root);
	@override late final _TranslationsPopupsHandbookDe handbook = _TranslationsPopupsHandbookDe._(_root);
	@override late final _TranslationsPopupsMailDeleteDe mailDelete = _TranslationsPopupsMailDeleteDe._(_root);
	@override late final _TranslationsPopupsMailPeopleDe mailPeople = _TranslationsPopupsMailPeopleDe._(_root);
	@override late final _TranslationsPopupsMensaOpeningHoursDe mensaOpeningHours = _TranslationsPopupsMensaOpeningHoursDe._(_root);
	@override late final _TranslationsPopupsNeedUpdateDe needUpdate = _TranslationsPopupsNeedUpdateDe._(_root);
	@override late final _TranslationsPopupsResetDe reset = _TranslationsPopupsResetDe._(_root);
	@override late final _TranslationsPopupsWipDe wip = _TranslationsPopupsWipDe._(_root);
}

// Path: notifications
class _TranslationsNotificationsDe implements TranslationsNotificationsEn {
	_TranslationsNotificationsDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsNotificationsNewMailDe newMail = _TranslationsNotificationsNewMailDe._(_root);
}

// Path: features.map
class _TranslationsFeaturesMapDe with FeatureName implements TranslationsFeaturesMapEn {
	_TranslationsFeaturesMapDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Campus';
	@override String get long => 'Campusplan';
}

// Path: features.myEvents
class _TranslationsFeaturesMyEventsDe with FeatureName implements TranslationsFeaturesMyEventsEn {
	_TranslationsFeaturesMyEventsDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'My Events';
	@override String get long => 'Meine Events';
}

// Path: features.mensa
class _TranslationsFeaturesMensaDe with FeatureName implements TranslationsFeaturesMensaEn {
	_TranslationsFeaturesMensaDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Mensa';
	@override String get long => 'Mensa';
}

// Path: features.links
class _TranslationsFeaturesLinksDe with FeatureName implements TranslationsFeaturesLinksEn {
	_TranslationsFeaturesLinksDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Links';
	@override String get long => 'Links';
}

// Path: features.handbook
class _TranslationsFeaturesHandbookDe with FeatureName implements TranslationsFeaturesHandbookEn {
	_TranslationsFeaturesHandbookDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Handbuch';
	@override String get long => 'Handbuch';
}

// Path: features.audio
class _TranslationsFeaturesAudioDe with FeatureName implements TranslationsFeaturesAudioEn {
	_TranslationsFeaturesAudioDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Guides';
	@override String get long => 'Audio-Guides';
}

// Path: features.faq
class _TranslationsFeaturesFaqDe with FeatureName implements TranslationsFeaturesFaqEn {
	_TranslationsFeaturesFaqDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'FAQ';
	@override String get long => 'FAQ';
}

// Path: features.contacts
class _TranslationsFeaturesContactsDe with FeatureName implements TranslationsFeaturesContactsEn {
	_TranslationsFeaturesContactsDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Kontakte';
	@override String get long => 'Kontakte';
}

// Path: features.emails
class _TranslationsFeaturesEmailsDe with FeatureName implements TranslationsFeaturesEmailsEn {
	_TranslationsFeaturesEmailsDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'E-Mails';
	@override String get long => 'E-Mails';
}

// Path: main.home
class _TranslationsMainHomeDe implements TranslationsMainHomeEn {
	_TranslationsMainHomeDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String nextEvents({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(n,
		one: 'Nächstes Event',
		other: 'Nächste Events',
	);
	@override String get news => 'Neuigkeiten';
}

// Path: main.calendar
class _TranslationsMainCalendarDe implements TranslationsMainCalendarEn {
	_TranslationsMainCalendarDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Kalender';
	@override String get events => 'Events';
}

// Path: main.features
class _TranslationsMainFeaturesDe implements TranslationsMainFeaturesEn {
	_TranslationsMainFeaturesDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Funktionen';
	@override String get info => 'Du verwendest eine Funktion sehr häufig?\nMit dem Herz gelangen Sie auf dem Startbildschirm.';
}

// Path: main.settings
class _TranslationsMainSettingsDe implements TranslationsMainSettingsEn {
	_TranslationsMainSettingsDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Einstellungen';
	@override String get language => 'Sprache';
	@override String get account => 'OVGU-Account';
	@override String get sync => 'Synchronisation';
	@override String get reset => 'Daten zurücksetzen';
	@override String get licenses => 'Lizenzen';
	@override String get about => 'Über die App';
	@override String get dev => 'Entwickler-Einstellungen';
}

// Path: about.idea
class _TranslationsAboutIdeaDe implements TranslationsAboutIdeaEn {
	_TranslationsAboutIdeaDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Idee';
	@override List<String> get people => [
		'M.A. Anne-Katrin Güldenpfennig',
		'Christin Scheil',
		'IKUS',
		'Wohnheimtutoren des Studentenwerks',
		'Fachschaftrat der Informatik',
	];
}

// Path: about.technicalImplementation
class _TranslationsAboutTechnicalImplementationDe implements TranslationsAboutTechnicalImplementationEn {
	_TranslationsAboutTechnicalImplementationDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Technische Umsetzung';
	@override List<String> get people => [
		'Tien Do Nam<br>August 2020 - heute<br>ehemaliger Student an der FIN<br><a href="https://tiendonam.de">tiendonam.de</a>',
	];
}

// Path: event.registration
class _TranslationsEventRegistrationDe implements TranslationsEventRegistrationEn {
	_TranslationsEventRegistrationDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Registrierung';
	@override String slots({required Object registered, required Object slots}) => '${registered}/${slots} Personen';
	@override late final _TranslationsEventRegistrationStatusDe status = _TranslationsEventRegistrationStatusDe._(_root);
	@override String get register => 'Anmelden';
	@override String get cancel => 'Abmelden';
	@override String get canceling => 'Abmelden...';
}

// Path: mails.actions
class _TranslationsMailsActionsDe implements TranslationsMailsActionsEn {
	_TranslationsMailsActionsDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get account => 'Account';
	@override String get sync => 'Laden';
	@override String get send => 'Senden';
}

// Path: mailMessageSend.errors
class _TranslationsMailMessageSendErrorsDe implements TranslationsMailMessageSendErrorsEn {
	_TranslationsMailMessageSendErrorsDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get missingFrom => 'Von-Adresse fehlt';
	@override String get missingTo => 'An-Adresse fehlt';
	@override String get missingSubject => 'Betreff fehlt';
	@override String get missingContent => 'Inhalt fehlt';
}

// Path: mensa.locations
class _TranslationsMensaLocationsDe implements TranslationsMensaLocationsEn {
	_TranslationsMensaLocationsDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get uniCampusDown => 'UniCampus\nUnterer Saal';
	@override String get uniCampusUp => 'UniCampus\nOberer Saal';
	@override String get zschokke => 'Kellercafé\nZschokkestraße';
	@override String get herrenkrug => 'Café\nHerrenkrug';
	@override String get pier16 => 'Café\nPier 16';
}

// Path: mensa.tags
class _TranslationsMensaTagsDe implements TranslationsMensaTagsEn {
	_TranslationsMensaTagsDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get vegan => 'Vegan';
	@override String get vegetarian => 'Vegetarisch';
	@override String get garlic => 'Knoblauch';
	@override String get fish => 'Fisch';
	@override String get chicken => 'Huhn';
	@override String get beef => 'Rind';
	@override String get pig => 'Schwein';
	@override String get soup => 'Suppe';
	@override String get alcohol => 'Alkohol';
	@override String get sides => 'Beilagen';
}

// Path: registerEvent.errors
class _TranslationsRegisterEventErrorsDe implements TranslationsRegisterEventErrorsEn {
	_TranslationsRegisterEventErrorsDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get validation => 'Bitte alle Felder ausfüllen.';
	@override String get closed => 'Registrierung geschlossen.';
	@override String get full => 'Plätze voll.';
}

// Path: sync.items
class _TranslationsSyncItemsDe implements TranslationsSyncItemsEn {
	_TranslationsSyncItemsDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get news => 'Neuigkeiten';
	@override String get calendar => 'Kalender';
	@override String get mensa => 'Mensa';
	@override String get links => 'Links';
	@override String get handbook => 'Handbuch';
	@override String get audio => 'Audio';
	@override String get faq => 'FAQ';
	@override String get contact => 'Kontakte';
	@override String get emails => 'E-Mails';
	@override String get appConfig => 'App-Konfiguration';
}

// Path: components.eventCard
class _TranslationsComponentsEventCardDe implements TranslationsComponentsEventCardEn {
	_TranslationsComponentsEventCardDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get noPlace => 'Kein Ort angegeben';
}

// Path: components.mapWithMarker
class _TranslationsComponentsMapWithMarkerDe implements TranslationsComponentsMapWithMarkerEn {
	_TranslationsComponentsMapWithMarkerDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get openMapApp => 'Navigation';
}

// Path: popups.channel
class _TranslationsPopupsChannelDe implements TranslationsPopupsChannelEn {
	_TranslationsPopupsChannelDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Kanäle';
	@override String get all => 'Alle';
}

// Path: popups.date
class _TranslationsPopupsDateDe implements TranslationsPopupsDateEn {
	_TranslationsPopupsDateDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get normal => 'Folgende Events gibt es an diesem Tag:';
	@override String get empty => 'Es gibt keine Events an diesem Tag.';
}

// Path: popups.error
class _TranslationsPopupsErrorDe implements TranslationsPopupsErrorEn {
	_TranslationsPopupsErrorDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ein Fehler ist aufgetreten.';
	@override String get ok => 'OK';
}

// Path: popups.eventAdded
class _TranslationsPopupsEventAddedDe implements TranslationsPopupsEventAddedEn {
	_TranslationsPopupsEventAddedDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Event markiert';
	@override String content({required Object event}) => '"${event}" wurde zu deine persönliche Liste hinzugefügt.';
	@override String get undo => 'Rückgängig';
	@override String get list => 'Zur Liste';
	@override String get ok => 'Okay';
}

// Path: popups.eventPast
class _TranslationsPopupsEventPastDe implements TranslationsPopupsEventPastEn {
	_TranslationsPopupsEventPastDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Event ist schon vorbei';
	@override String get info => 'Du kannst nur Events hinzufügen, die in der Zukunft liegen.';
	@override String get ok => 'OK';
}

// Path: popups.eventUnregister
class _TranslationsPopupsEventUnregisterDe implements TranslationsPopupsEventUnregisterEn {
	_TranslationsPopupsEventUnregisterDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Anmeldung löschen';
	@override String get info => 'Du wirst deine aktuelle Position in der Liste verlieren.';
	@override String get cancel => 'Abbrechen';
	@override String get delete => 'Löschen';
}

// Path: popups.handbook
class _TranslationsPopupsHandbookDe implements TranslationsPopupsHandbookEn {
	_TranslationsPopupsHandbookDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Inhaltsverzeichnis';
	@override String page({required Object page}) => 'S. ${page}';
}

// Path: popups.mailDelete
class _TranslationsPopupsMailDeleteDe implements TranslationsPopupsMailDeleteEn {
	_TranslationsPopupsMailDeleteDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'E-Mail löschen';
	@override String get info => 'Bist du dir sicher?';
	@override String get delete => 'Löschen';
	@override String get cancel => 'Abbrechen';
}

// Path: popups.mailPeople
class _TranslationsPopupsMailPeopleDe implements TranslationsPopupsMailPeopleEn {
	_TranslationsPopupsMailPeopleDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Personen';
	@override String get from => 'Von';
	@override String get to => 'An';
	@override String get cc => 'CC';
}

// Path: popups.mensaOpeningHours
class _TranslationsPopupsMensaOpeningHoursDe implements TranslationsPopupsMensaOpeningHoursEn {
	_TranslationsPopupsMensaOpeningHoursDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Öffnungszeiten';
}

// Path: popups.needUpdate
class _TranslationsPopupsNeedUpdateDe implements TranslationsPopupsNeedUpdateEn {
	_TranslationsPopupsNeedUpdateDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Update notwendig';
	@override String get info => 'Es werden die Offline-Daten verwendet, solange du die App nicht auf die neuste Version aktualisierst.';
	@override String get ok => 'OK';
}

// Path: popups.reset
class _TranslationsPopupsResetDe implements TranslationsPopupsResetEn {
	_TranslationsPopupsResetDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Daten zurücksetzen';
	@override String get content => 'Die App wird auf den Werkszustand gebracht. Fortsetzen?';
	@override String get reset => 'Zurücksetzen';
	@override String get cancel => 'Abbrechen';
}

// Path: popups.wip
class _TranslationsPopupsWipDe implements TranslationsPopupsWipEn {
	_TranslationsPopupsWipDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'In Arbeit';
	@override String get ok => 'OK';
}

// Path: notifications.newMail
class _TranslationsNotificationsNewMailDe implements TranslationsNotificationsNewMailEn {
	_TranslationsNotificationsNewMailDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String title({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(n,
		one: 'Neue E-Mail',
		other: '${n} neue E-Mails',
	);
}

// Path: event.registration.status
class _TranslationsEventRegistrationStatusDe implements TranslationsEventRegistrationStatusEn {
	_TranslationsEventRegistrationStatusDe._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get open => 'OFFEN';
	@override String get registered => 'ANGEMELDET';
	@override String waitingList({required Object position}) => 'WARTELISTE (${position})';
	@override String get full => 'VOLL';
	@override String get closed => 'GESCHLOSSEN';
}
