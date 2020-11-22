import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/init.dart';
import 'package:ikus_app/screens/main_screen.dart';
import 'package:ikus_app/screens/welcome_screen.dart';
import 'package:ikus_app/service/orientation_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/ui.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  await initializeDateFormatting();
  runApp(TranslationProvider(child: IkusApp()));
}

class IkusApp extends StatefulWidget {
  @override
  IkusAppState createState() => IkusAppState();
}

class IkusAppState extends State<IkusApp> {

  final NavigatorObserver _navObserver = NavigatorObserverWithOrientation();
  bool _initialized = false;
  Widget _home;

  @override
  void initState() {
    super.initState();

    // initialize from storage
    Init.init().whenComplete(() {
      setState((){
        _home = SettingsService.instance.getWelcome() ? WelcomeScreen() : MainScreen();
        _initialized = true;
      });
    }).whenComplete(() async {
      await Init.postInit(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    precacheImage(AssetImage("assets/img/maps/campus-main.jpg"), context);
    precacheImage(AssetImage("assets/img/maps/campus-med.jpg"), context);

    if (!_initialized)
      return Container(color: OvguColor.primary);

    return MaterialApp(
      title: 'OVGU',
      debugShowCheckedModeBanner: false,
      builder: Adaptive.getBehaviour(),
      theme: ThemeData(
        primaryColor: OvguColor.primary,
        accentColor: OvguColor.secondary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _home,
      navigatorObservers: [ _navObserver ],
    );
  }
}
