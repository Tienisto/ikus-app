import 'package:flutter/material.dart';
import 'package:ikus_app/utility/callbacks.dart';

class OvguTextArea extends StatelessWidget {

  final String hint;
  final int minLines;
  final int maxLines;
  final StringCallback onChange;
  final TextEditingController? controller;

  const OvguTextArea({required this.hint, this.minLines = 6, this.maxLines = 6, required this.onChange, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 16),
      autocorrect: true,
      enableSuggestions: false,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        fillColor: Colors.white,
        filled: true
      ),
      onChanged: onChange,
    );
  }
}
