import 'package:flutter/material.dart';
import 'package:ikus_app/components/animated_progress_bar.dart';
import 'package:ikus_app/components/status_bar_color.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/screens/main_screen.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class ChangeLanguageScreen extends StatefulWidget {

  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {

  double _progress = 0;

  @override
  void initState() {
    super.initState();
    syncAll();
  }

  Future<void> syncAll() async {
    List<SyncableService> services = SyncableService.services;
    for (int i = 0; i < services.length; i++) {
      await services[i].sync(useNetwork: true);
      await sleep(100);
      setState(() {
        _progress = (i+1) / services.length;
      });
    }
    await sleep(100);
    setScreen(context, () => MainScreen(key: MainScreen.mainScreenKey));
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarColor(
      brightness: Brightness.dark,
      child: Scaffold(
        body: SizedBox.expand(
          child: Container(
            color: OvguColor.primary,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(t.changeLanguage.title, style: TextStyle(color: Colors.white, fontSize: 20)),
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 0, maxWidth: OvguPixels.maxWidth),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: AnimatedProgressBar(
                        progress: _progress,
                        reactDuration: Duration(milliseconds: 100),
                        backgroundColor: Colors.white,
                      )
                    ),
                  )
                ]
              )
            )
          )
        )
      )
    );
  }
}
