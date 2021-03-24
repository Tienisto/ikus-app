import 'package:flutter/material.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class CheckBoxText extends StatelessWidget {

  final BoolCallback callback;
  final bool value;
  final String text;

  const CheckBoxText({required this.callback, required this.value, required this.text});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(text),
      value: value,
      onChanged: callback,
      activeColor: OvguColor.primary,
    );
  }
}
