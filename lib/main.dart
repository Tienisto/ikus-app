import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ikus_app/gen/strings.g.dart';
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
    child: IkusApp(screen: openScreen),
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    PersistentService.instance.logError(details.exception.toString(), details.stack?.toString());
    FlutterError.presentError(details);
  };

  runApp(app);
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
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          foregroundColor: Colors.white,
          color: OvguColor.primary, // already set in android styles.xml, but just to make sure
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: OvguColor.primary),
      ),
      home: _home!,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocaleUtils.supportedLocales,
      navigatorObservers: [ _navObserver ],
    );
  }
}
