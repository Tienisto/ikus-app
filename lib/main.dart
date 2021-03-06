import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/init.dart';
import 'package:ikus_app/screens/main_screen.dart';
import 'package:ikus_app/screens/welcome_screen.dart';
import 'package:ikus_app/service/orientation_service.dart';
import 'package:ikus_app/service/persistent_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

void main() async {
  final openScreen = await Init.preInit();
  final app = TranslationProvider(
    child: IkusApp(screen: openScreen)
  );

  runZonedGuarded(() async {
    runApp(app);
  }, (error, stackTrace) {
    print('ERROR: $error');
    print(stackTrace);
    PersistentService.instance.logError(error.toString(), stackTrace.toString());
  });

  FlutterError.onError = (FlutterErrorDetails details) {
    PersistentService.instance.logError(details.exception.toString(), details.stack?.toString());
    FlutterError.presentError(details);
  };
}

class IkusApp extends StatefulWidget {

  final SimpleWidgetBuilder? screen; // will open this screen after init
  const IkusApp({this.screen});

  @override
  IkusAppState createState() => IkusAppState();
}

class IkusAppState extends State<IkusApp> {

  final NavigatorObserver _navObserver = NavigatorObserverWithOrientation();
  Widget? _home;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Init.init();
    setState((){
      _home = SettingsService.instance.getWelcome() ? WelcomeScreen() : MainScreen(screen: widget.screen, key: MainScreen.mainScreenKey);
    });
    await Init.postInit();
  }

  @override
  Widget build(BuildContext context) {

    precacheImage(AssetImage("assets/img/maps/campus-main.jpg"), context);
    precacheImage(AssetImage("assets/img/maps/campus-med.jpg"), context);

    if (_home == null)
      return Container(color: OvguColor.primary);

    return MaterialApp(
      title: 'OVGU',
      debugShowCheckedModeBanner: false,
      builder: Adaptive.getBehaviour(),
      theme: ThemeData(
        primaryColor: OvguColor.primary,
        accentColor: OvguColor.secondary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
          brightness: Brightness.dark,
          color: OvguColor.primary
        )
      ),
      home: _home!,
      navigatorObservers: [ _navObserver ],
    );
  }
}
