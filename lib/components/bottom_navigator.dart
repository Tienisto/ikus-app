import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';
import 'package:ikus_app/utility/extensions.dart';

List<IconData> _icons = [
  Icons.home,
  Icons.widgets,
  Icons.settings
];

class BottomNavigator extends StatelessWidget {

  final int selectedIndex;
  final IndexCallback callback;

  const BottomNavigator(this.selectedIndex, this.callback);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: OvguColor.primary),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[200],
        items: _icons.mapIndexed((icons, index) {
          return BottomNavigationBarItem(
            icon: Icon(icons),
            title: Text(t.main.bottomBar[index]),
          );
        }).toList(),
        currentIndex: selectedIndex,
        onTap: callback,
      ),
    );
  }
}
