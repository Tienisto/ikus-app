///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  );

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsMetaEn meta = TranslationsMetaEn._(_root);
	late final TranslationsFeaturesEn features = TranslationsFeaturesEn._(_root);
	late final TranslationsWelcomeEn welcome = TranslationsWelcomeEn._(_root);
	late final TranslationsTutorialEn tutorial = TranslationsTutorialEn._(_root);
	late final TranslationsMainEn main = TranslationsMainEn._(_root);
	late final TranslationsAboutEn about = TranslationsAboutEn._(_root);
	late final TranslationsContactsEn contacts = TranslationsContactsEn._(_root);
	late final TranslationsEventEn event = TranslationsEventEn._(_root);
	late final TranslationsFaqEn faq = TranslationsFaqEn._(_root);
	late final TranslationsHandbookEn handbook = TranslationsHandbookEn._(_root);
	late final TranslationsLinksEn links = TranslationsLinksEn._(_root);
	late final TranslationsMailsEn mails = TranslationsMailsEn._(_root);
	late final TranslationsMailMessageEn mailMessage = TranslationsMailMessageEn._(_root);
	late final TranslationsMailMessageSendEn mailMessageSend = TranslationsMailMessageSendEn._(_root);
	late final TranslationsMapEn map = TranslationsMapEn._(_root);
	late final TranslationsMensaEn mensa = TranslationsMensaEn._(_root);
	late final TranslationsMyEventsEn myEvents = TranslationsMyEventsEn._(_root);
	late final TranslationsRegisterEventEn registerEvent = TranslationsRegisterEventEn._(_root);
	late final TranslationsOvguAccountEn ovguAccount = TranslationsOvguAccountEn._(_root);
	late final TranslationsAudioListEn audioList = TranslationsAudioListEn._(_root);
	late final TranslationsAudioEn audio = TranslationsAudioEn._(_root);
	late final TranslationsPostEn post = TranslationsPostEn._(_root);
	late final TranslationsSyncEn sync = TranslationsSyncEn._(_root);
	late final TranslationsDevEn dev = TranslationsDevEn._(_root);
	late final TranslationsChangeLanguageEn changeLanguage = TranslationsChangeLanguageEn._(_root);
	late final TranslationsComponentsEn components = TranslationsComponentsEn._(_root);
	late final TranslationsPopupsEn popups = TranslationsPopupsEn._(_root);
	late final TranslationsNotificationsEn notifications = TranslationsNotificationsEn._(_root);
	String timeFormat({required Object time}) => '${time}';
}

// Path: meta
class TranslationsMetaEn {
	TranslationsMetaEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get appName => 'Welcome to OVGU';
}

// Path: features
class TranslationsFeaturesEn {
	TranslationsFeaturesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsFeaturesMapEn map = TranslationsFeaturesMapEn._(_root);
	late final TranslationsFeaturesMyEventsEn myEvents = TranslationsFeaturesMyEventsEn._(_root);
	late final TranslationsFeaturesMensaEn mensa = TranslationsFeaturesMensaEn._(_root);
	late final TranslationsFeaturesLinksEn links = TranslationsFeaturesLinksEn._(_root);
	late final TranslationsFeaturesHandbookEn handbook = TranslationsFeaturesHandbookEn._(_root);
	late final TranslationsFeaturesAudioEn audio = TranslationsFeaturesAudioEn._(_root);
	late final TranslationsFeaturesFaqEn faq = TranslationsFeaturesFaqEn._(_root);
	late final TranslationsFeaturesContactsEn contacts = TranslationsFeaturesContactsEn._(_root);
	late final TranslationsFeaturesEmailsEn emails = TranslationsFeaturesEmailsEn._(_root);
}

// Path: welcome
class TranslationsWelcomeEn {
	TranslationsWelcomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => _root.meta.appName;
	String get intro => 'You\'ve just enrolled at Magdeburg University? With this app, you get an overview of all important information about life at OVGU.';
	String get selectLanguage => 'Select language:';
	String get english => 'English';
	String get german => 'German';
	String get start => 'Start App';
	String get loading => 'Loading Data...';
}

// Path: tutorial
class TranslationsTutorialEn {
	TranslationsTutorialEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	List<String> get steps => [
		'This is the start screen.\nHere you can find the latest news.',
		'On the 2nd page, you can find the calendar so you won\'t miss any event!',
		'On the 3rd page, you\'ll find a list of all features.',
		'You use a particular feature often?\nYou can tap on the heart to add it to the start screen.',
		'All features you liked will appear here on the top.',
		'That\'s it! :)',
	];
	String get skip => 'Skip';
	String get next => 'Next';
	String get done => 'Done';
}

// Path: main
class TranslationsMainEn {
	TranslationsMainEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	List<String> get bottomBar => [
		'Home',
		'Calendar',
		'Features',
		'Settings',
	];
	late final TranslationsMainHomeEn home = TranslationsMainHomeEn._(_root);
	late final TranslationsMainCalendarEn calendar = TranslationsMainCalendarEn._(_root);
	late final TranslationsMainFeaturesEn features = TranslationsMainFeaturesEn._(_root);
	late final TranslationsMainSettingsEn settings = TranslationsMainSettingsEn._(_root);
}

// Path: about
class TranslationsAboutEn {
	TranslationsAboutEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'About the app';
	String get main => 'The ${_root.meta.appName} app is an initiative of the Otto-von-Guericke University Magdeburg. The goal is to make everyday student life easier - especially for international students.';
	late final TranslationsAboutIdeaEn idea = TranslationsAboutIdeaEn._(_root);
	late final TranslationsAboutTechnicalImplementationEn technicalImplementation = TranslationsAboutTechnicalImplementationEn._(_root);
	String get contribute => 'This app is open source.<br>You can checkout the code <a href="https://github.com/Tienisto/ikus-app">here</a>.<br>Feel free to create an <a href="https://github.com/Tienisto/ikus-app/issues">issue</a> or a <a href="https://github.com/Tienisto/ikus-app/pulls">pull request</a>.';
}

// Path: contacts
class TranslationsContactsEn {
	TranslationsContactsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Contacts';
}

// Path: event
class TranslationsEventEn {
	TranslationsEventEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Event';
	late final TranslationsEventRegistrationEn registration = TranslationsEventRegistrationEn._(_root);
	String get when => 'When?';
	String get to => 'to';
	String get where => 'Where?';
}

// Path: faq
class TranslationsFaqEn {
	TranslationsFaqEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Frequently Asked Questions';
	String get search => 'Search Question...';
	String get suggestions => 'Suggestions';
	String get noResults => 'No Results.';
}

// Path: handbook
class TranslationsHandbookEn {
	TranslationsHandbookEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Handbook';
	String get wip => 'Handbook is in progress.';
}

// Path: links
class TranslationsLinksEn {
	TranslationsLinksEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Useful Links';
}

// Path: mails
class TranslationsMailsEn {
	TranslationsMailsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Emails';
	String get alpha => 'Still in alpha. Optimizations are coming.';
	late final TranslationsMailsActionsEn actions = TranslationsMailsActionsEn._(_root);
	String get inbox => 'Inbox';
	String get sent => 'Sent';
	String sync({required Object text}) => 'Syncing: ${text}';
	String get deleting => 'Deleting...';
	String get replyPrefix => 'from ';
}

// Path: mailMessage
class TranslationsMailMessageEn {
	TranslationsMailMessageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Email';
}

// Path: mailMessageSend
class TranslationsMailMessageSendEn {
	TranslationsMailMessageSendEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Send Email';
	String get from => 'From';
	String get to => 'To';
	String get cc => 'CC';
	String get subject => 'Subject';
	String get content => 'Content';
	String get send => 'Send';
	String get sending => 'Sending Email...';
	late final TranslationsMailMessageSendErrorsEn errors = TranslationsMailMessageSendErrorsEn._(_root);
}

// Path: map
class TranslationsMapEn {
	TranslationsMapEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Campus Map';
	String get main => 'Main Campus';
	String get med => 'Medicine Campus';
}

// Path: mensa
class TranslationsMensaEn {
	TranslationsMensaEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Mensa';
	late final TranslationsMensaLocationsEn locations = TranslationsMensaLocationsEn._(_root);
	String lastUpdate({required Object timestamp}) => 'Last Update: ${timestamp}';
	String today({required Object date}) => 'Today, ${date}';
	String tomorrow({required Object date}) => 'Tomorrow, ${date}';
	String get noData => 'No data available...';
	late final TranslationsMensaTagsEn tags = TranslationsMensaTagsEn._(_root);
}

// Path: myEvents
class TranslationsMyEventsEn {
	TranslationsMyEventsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'My Events';
	String get info => 'You can select events which are important to you. These events appear here and under "Next Events" on the start screen.';
}

// Path: registerEvent
class TranslationsRegisterEventEn {
	TranslationsRegisterEventEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Register';
	String get matriculationNumber => 'Matriculation No.';
	String get firstName => 'First Name';
	String get lastName => 'Last Name';
	String get email => 'Email';
	String get address => 'Address';
	String get country => 'Home Country';
	String get register => 'Register';
	String get registering => 'Registering...';
	String get disclaimer => 'The data will not be passed on to third parties. The data is deleted as soon as it is no longer required to achieve the purpose for which it was collected.';
	late final TranslationsRegisterEventErrorsEn errors = TranslationsRegisterEventErrorsEn._(_root);
}

// Path: ovguAccount
class TranslationsOvguAccountEn {
	TranslationsOvguAccountEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'OVGU Account';
	String get info => 'You can access your mails as soon as you setup the OVGU account.';
	String get loginCredentials => 'Login Credentials';
	String get name => 'Name';
	String get password => 'Password';
	String get login => 'Login';
	String get loggedInAs => 'Logged in as';
	String get logout => 'Logout';
	String get privacy => 'Your login credentials will be encrypted and only stored on your device.';
	String get authenticating => 'Authenticating';
}

// Path: audioList
class TranslationsAudioListEn {
	TranslationsAudioListEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Audio Guides';
	String get empty => 'Work in progress.';
}

// Path: audio
class TranslationsAudioEn {
	TranslationsAudioEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Audio Guide';
}

// Path: post
class TranslationsPostEn {
	TranslationsPostEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Post';
}

// Path: sync
class TranslationsSyncEn {
	TranslationsSyncEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Synchronization';
	String get info => 'This app regularly downloads data from the server to keep you up to date. You can use the app offline using the locally stored data.';
	late final TranslationsSyncItemsEn items = TranslationsSyncItemsEn._(_root);
}

// Path: dev
class TranslationsDevEn {
	TranslationsDevEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Developer Settings';
}

// Path: changeLanguage
class TranslationsChangeLanguageEn {
	TranslationsChangeLanguageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Loading English Data...';
}

// Path: components
class TranslationsComponentsEn {
	TranslationsComponentsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsComponentsEventCardEn eventCard = TranslationsComponentsEventCardEn._(_root);
	late final TranslationsComponentsMapWithMarkerEn mapWithMarker = TranslationsComponentsMapWithMarkerEn._(_root);
}

// Path: popups
class TranslationsPopupsEn {
	TranslationsPopupsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsPopupsChannelEn channel = TranslationsPopupsChannelEn._(_root);
	late final TranslationsPopupsDateEn date = TranslationsPopupsDateEn._(_root);
	late final TranslationsPopupsErrorEn error = TranslationsPopupsErrorEn._(_root);
	late final TranslationsPopupsEventAddedEn eventAdded = TranslationsPopupsEventAddedEn._(_root);
	late final TranslationsPopupsEventPastEn eventPast = TranslationsPopupsEventPastEn._(_root);
	late final TranslationsPopupsEventUnregisterEn eventUnregister = TranslationsPopupsEventUnregisterEn._(_root);
	late final TranslationsPopupsHandbookEn handbook = TranslationsPopupsHandbookEn._(_root);
	late final TranslationsPopupsMailDeleteEn mailDelete = TranslationsPopupsMailDeleteEn._(_root);
	late final TranslationsPopupsMailPeopleEn mailPeople = TranslationsPopupsMailPeopleEn._(_root);
	late final TranslationsPopupsMensaOpeningHoursEn mensaOpeningHours = TranslationsPopupsMensaOpeningHoursEn._(_root);
	late final TranslationsPopupsNeedUpdateEn needUpdate = TranslationsPopupsNeedUpdateEn._(_root);
	late final TranslationsPopupsResetEn reset = TranslationsPopupsResetEn._(_root);
	late final TranslationsPopupsWipEn wip = TranslationsPopupsWipEn._(_root);
}

// Path: notifications
class TranslationsNotificationsEn {
	TranslationsNotificationsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsNotificationsNewMailEn newMail = TranslationsNotificationsNewMailEn._(_root);
}

// Path: features.map
class TranslationsFeaturesMapEn with FeatureName {
	TranslationsFeaturesMapEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get short => 'Campus';
	@override String get long => 'Campus Map';
}

// Path: features.myEvents
class TranslationsFeaturesMyEventsEn with FeatureName {
	TranslationsFeaturesMyEventsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get short => 'My Events';
	@override String get long => 'My Events';
}

// Path: features.mensa
class TranslationsFeaturesMensaEn with FeatureName {
	TranslationsFeaturesMensaEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get short => 'Mensa';
	@override String get long => 'Mensa';
}

// Path: features.links
class TranslationsFeaturesLinksEn with FeatureName {
	TranslationsFeaturesLinksEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get short => 'Links';
	@override String get long => 'Links';
}

// Path: features.handbook
class TranslationsFeaturesHandbookEn with FeatureName {
	TranslationsFeaturesHandbookEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get short => 'Handbook';
	@override String get long => 'Handbook';
}

// Path: features.audio
class TranslationsFeaturesAudioEn with FeatureName {
	TranslationsFeaturesAudioEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get short => 'Guides';
	@override String get long => 'Audio Guides';
}

// Path: features.faq
class TranslationsFeaturesFaqEn with FeatureName {
	TranslationsFeaturesFaqEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get short => 'FAQ';
	@override String get long => 'FAQ';
}

// Path: features.contacts
class TranslationsFeaturesContactsEn with FeatureName {
	TranslationsFeaturesContactsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get short => 'Contacts';
	@override String get long => 'Contacts';
}

// Path: features.emails
class TranslationsFeaturesEmailsEn with FeatureName {
	TranslationsFeaturesEmailsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get short => 'Emails';
	@override String get long => 'Emails';
}

// Path: main.home
class TranslationsMainHomeEn {
	TranslationsMainHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String nextEvents({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'Next Event',
		other: 'Next Events',
	);
	String get news => 'News';
}

// Path: main.calendar
class TranslationsMainCalendarEn {
	TranslationsMainCalendarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Calendar';
	String get events => 'Events';
}

// Path: main.features
class TranslationsMainFeaturesEn {
	TranslationsMainFeaturesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Features';
	String get info => 'You often use a feature?\nYou can tap on the heart to add it to the start screen.';
}

// Path: main.settings
class TranslationsMainSettingsEn {
	TranslationsMainSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Settings';
	String get language => 'Language';
	String get account => 'OVGU Account';
	String get sync => 'Synchronization';
	String get reset => 'Reset Data';
	String get licenses => 'Licenses';
	String get about => 'About the app';
	String get dev => 'Developer Settings';
}

// Path: about.idea
class TranslationsAboutIdeaEn {
	TranslationsAboutIdeaEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Idea';
	List<String> get people => [
		'M.A. Anne-Katrin Güldenpfennig',
		'Christin Scheil',
		'IKUS',
		'Dormitory Advisors of the Studentenwerk',
		'Fachschaftsrat Informatik',
	];
}

// Path: about.technicalImplementation
class TranslationsAboutTechnicalImplementationEn {
	TranslationsAboutTechnicalImplementationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Technical Implementation';
	List<String> get people => [
		'Tien Do Nam<br>August 2020 - today<br>former Student at FIN<br><a href="https://tiendonam.de">tiendonam.de</a>',
	];
}

// Path: event.registration
class TranslationsEventRegistrationEn {
	TranslationsEventRegistrationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Registration';
	String slots({required Object registered, required Object slots}) => '${registered}/${slots} People';
	late final TranslationsEventRegistrationStatusEn status = TranslationsEventRegistrationStatusEn._(_root);
	String get register => 'Register';
	String get cancel => 'Cancel';
	String get canceling => 'Canceling...';
}

// Path: mails.actions
class TranslationsMailsActionsEn {
	TranslationsMailsActionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get account => 'Account';
	String get sync => 'Sync';
	String get send => 'Send';
}

// Path: mailMessageSend.errors
class TranslationsMailMessageSendErrorsEn {
	TranslationsMailMessageSendErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get missingFrom => 'From address missing';
	String get missingTo => 'To address missing';
	String get missingSubject => 'Subject missing';
	String get missingContent => 'Content missing';
}

// Path: mensa.locations
class TranslationsMensaLocationsEn {
	TranslationsMensaLocationsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get uniCampusDown => 'UniCampus\nGround Floor';
	String get uniCampusUp => 'UniCampus\nUpper Floor';
	String get zschokke => 'Café\nZschokkestraße';
	String get herrenkrug => 'Café\nHerrenkrug';
	String get pier16 => 'Café\nPier 16';
}

// Path: mensa.tags
class TranslationsMensaTagsEn {
	TranslationsMensaTagsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get vegan => 'Vegan';
	String get vegetarian => 'Vegetarian';
	String get garlic => 'Garlic';
	String get fish => 'Fish';
	String get chicken => 'Chicken';
	String get beef => 'Beef';
	String get pig => 'Pig';
	String get soup => 'Soup';
	String get alcohol => 'Alcohol';
	String get sides => 'Sides';
}

// Path: registerEvent.errors
class TranslationsRegisterEventErrorsEn {
	TranslationsRegisterEventErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get validation => 'Please fill in all fields.';
	String get closed => 'Registration closed.';
	String get full => 'Full.';
}

// Path: sync.items
class TranslationsSyncItemsEn {
	TranslationsSyncItemsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get news => 'News';
	String get calendar => 'Calendar';
	String get mensa => 'Mensa';
	String get links => 'Links';
	String get handbook => 'Handbook';
	String get audio => 'Audio';
	String get faq => 'FAQ';
	String get contact => 'Contacts';
	String get emails => 'Emails';
	String get appConfig => 'App Configuration';
}

// Path: components.eventCard
class TranslationsComponentsEventCardEn {
	TranslationsComponentsEventCardEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get noPlace => 'No location specified';
}

// Path: components.mapWithMarker
class TranslationsComponentsMapWithMarkerEn {
	TranslationsComponentsMapWithMarkerEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get openMapApp => 'Navigation';
}

// Path: popups.channel
class TranslationsPopupsChannelEn {
	TranslationsPopupsChannelEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Channels';
	String get all => 'All';
}

// Path: popups.date
class TranslationsPopupsDateEn {
	TranslationsPopupsDateEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get normal => 'Following events are on this day:';
	String get empty => 'There are no events on this day.';
}

// Path: popups.error
class TranslationsPopupsErrorEn {
	TranslationsPopupsErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'An error occurred.';
	String get ok => 'OK';
}

// Path: popups.eventAdded
class TranslationsPopupsEventAddedEn {
	TranslationsPopupsEventAddedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Event added';
	String content({required Object event}) => '"${event}" has been added to your personal list.';
	String get undo => 'Undo';
	String get list => 'Show List';
	String get ok => 'Okay';
}

// Path: popups.eventPast
class TranslationsPopupsEventPastEn {
	TranslationsPopupsEventPastEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Event is already over';
	String get info => 'You can only add events which are in the future.';
	String get ok => 'OK';
}

// Path: popups.eventUnregister
class TranslationsPopupsEventUnregisterEn {
	TranslationsPopupsEventUnregisterEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Delete Registration';
	String get info => 'You will lose your current position.';
	String get cancel => 'Cancel';
	String get delete => 'Delete';
}

// Path: popups.handbook
class TranslationsPopupsHandbookEn {
	TranslationsPopupsHandbookEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Structure';
	String page({required Object page}) => 'P. ${page}';
}

// Path: popups.mailDelete
class TranslationsPopupsMailDeleteEn {
	TranslationsPopupsMailDeleteEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Delete Mail';
	String get info => 'Are you sure?';
	String get delete => 'Delete';
	String get cancel => 'Cancel';
}

// Path: popups.mailPeople
class TranslationsPopupsMailPeopleEn {
	TranslationsPopupsMailPeopleEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'People';
	String get from => 'From';
	String get to => 'To';
	String get cc => 'CC';
}

// Path: popups.mensaOpeningHours
class TranslationsPopupsMensaOpeningHoursEn {
	TranslationsPopupsMensaOpeningHoursEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Opening Hours';
}

// Path: popups.needUpdate
class TranslationsPopupsNeedUpdateEn {
	TranslationsPopupsNeedUpdateEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Update needed';
	String get info => 'Offline stored data will be used as long as you don\'t update the app to the latest version.';
	String get ok => 'OK';
}

// Path: popups.reset
class TranslationsPopupsResetEn {
	TranslationsPopupsResetEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Reset Data';
	String get content => 'The app will be reset to the factory settings. Continue?';
	String get reset => 'Reset';
	String get cancel => 'Cancel';
}

// Path: popups.wip
class TranslationsPopupsWipEn {
	TranslationsPopupsWipEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Work in progress';
	String get ok => 'OK';
}

// Path: notifications.newMail
class TranslationsNotificationsNewMailEn {
	TranslationsNotificationsNewMailEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String title({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'New Mail',
		other: '${n} new mails',
	);
}

// Path: event.registration.status
class TranslationsEventRegistrationStatusEn {
	TranslationsEventRegistrationStatusEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get open => 'OPEN';
	String get registered => 'REGISTERED';
	String waitingList({required Object position}) => 'WAITING LIST (${position})';
	String get full => 'FULL';
	String get closed => 'CLOSED';
}
