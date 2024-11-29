import 'package:flutter/material.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';
import 'package:ikus_app/utility/extensions.dart';

List<IconData> _icons = [
  Icons.home,
  Icons.today,
  Icons.apps,
  Icons.settings
];

class BottomNavigator extends StatelessWidget {

  final int selectedIndex;
  final IntCallback callback;
  final bool disabled;

  const BottomNavigator({required this.selectedIndex, required this.callback, required this.disabled});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: disabled ? Colors.grey[700] : OvguColor.primary),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        items: _icons.mapIndexed((icons, index) {
          return BottomNavigationBarItem(
            icon: Icon(icons),
            label: t.main.bottomBar[index],
          );
        }).toList(),
        currentIndex: selectedIndex,
        onTap: disabled ? null : callback,
      ),
    );
  }
}
