import 'package:flutter/material.dart';
import 'package:ikus_app/components/status_bar_color.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/screens/main_screen.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class ChangeLanguageScreen extends StatefulWidget {

  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  Animation<double> _animationProgress;
  double _progress = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 180),
    )..addListener(() {
      setState(() {
        _progress = _animationProgress.value;
      });
    });

    syncAll();
  }

  Future<void> syncAll() async {
    List<SyncableService> services = SyncableService.services;
    for (int i = 0; i < services.length; i++) {
      await services[i].sync(useCacheOnly: false);
      await sleep(200);
      setState(() {
        _animationProgress = Tween<double>(
            begin: i / services.length,
            end: (i+1) / services.length
        ).animate(_animationController);

        _animationController.forward(from: 0);
        _progress = (i+1) / services.length;
      });
    }
    await sleep(200);
    setScreen(context, () => MainScreen());
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
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: _progress,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
