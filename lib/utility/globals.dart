import 'package:flutter/cupertino.dart';
import 'package:ikus_app/model/coords.dart';
import 'package:ikus_app/service/orientation_service.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:map_launcher/map_launcher.dart' as map_launcher;

Future<void> sleep(int millis) async => await Future.delayed(Duration(milliseconds: millis));
Future<void> sleepRemaining(int millis, DateTime start) async {
  int remainingTime = millis - DateTime.now().difference(start).inMilliseconds;
  if (remainingTime > 0)
    await sleep(remainingTime);
}

void nextFrame(Callback callback) => WidgetsBinding.instance.addPostFrameCallback((_) => callback());

/// push another screen on top of the current screen
typedef Widget SimpleWidgetBuilder();
Future<void> pushScreen(BuildContext context, SimpleWidgetBuilder builder, [ScreenOrientation? orientation]) async {
  if (orientation != null)
    await Navigator.push(context, CupertinoPageRoute(builder: (context) => builder(), settings: RouteSettings(arguments: orientation)));
  else
    await Navigator.push(context, CupertinoPageRoute(builder: (context) => builder()));
}

/// clears screen stack and set the screen
Future<void> setScreen(BuildContext context, SimpleWidgetBuilder builder, [ScreenOrientation? orientation]) async {
  if (orientation != null)
    await Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => builder(), settings: RouteSettings(arguments: orientation)), (_) => false);
  else
    await Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => builder()), (_) => false);
}

Future<void> openMap(Coords coords, String? name) async {
  List<map_launcher.AvailableMap> availableMaps = await map_launcher.MapLauncher.installedMaps;
  map_launcher.AvailableMap app = availableMaps.firstWhere((a) => a.mapType == map_launcher.MapType.google, orElse: () => availableMaps.first);
  await app.showMarker(coords: map_launcher.Coords(coords.x, coords.y), title: name ?? '');
}