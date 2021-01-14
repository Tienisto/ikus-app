import 'package:flutter/material.dart';

class OvguAccount {

  final String name;
  final String password;
  final String mailAddress; // nullable

  OvguAccount({@required this.name, @required this.password, this.mailAddress});
}