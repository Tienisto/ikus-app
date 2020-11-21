import 'package:flutter/material.dart';
import 'package:ikus_app/utility/callbacks.dart';

enum TextFieldType {
  CLEAR, PASSWORD
}

class OvguTextField extends StatelessWidget {

  final String hint;
  final StringCallback onChange;
  final TextFieldType type;
  final IconData icon;

  const OvguTextField({@required this.hint, @required this.onChange, this.type = TextFieldType.CLEAR, this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(fontSize: 20),
      obscureText: type == TextFieldType.PASSWORD,
      autocorrect: type == TextFieldType.CLEAR,
      enableSuggestions: type == TextFieldType.CLEAR,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        fillColor: Colors.white,
        filled: true
      ),
      onChanged: onChange,
    );
  }
}
