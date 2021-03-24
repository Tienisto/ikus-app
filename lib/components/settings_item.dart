import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {

  final String left;
  final dynamic right;

  const SettingsItem({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(left, style: TextStyle(fontSize: 16))
        ),
        right
      ],
    );
  }
}
