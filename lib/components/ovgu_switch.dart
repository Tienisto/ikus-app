import 'package:flutter/material.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

enum SwitchState {
  LEFT, RIGHT
}

class OvguSwitch extends StatelessWidget {

  final SwitchState state;
  final String left, right;
  final SwitchCallback callback;

  const OvguSwitch({@required this.state, @required this.left, @required this.right, @required this.callback});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RaisedButton(
          color: state == SwitchState.LEFT ? OvguColor.primary : OvguColor.secondary,
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(15))
          ),
          onPressed: () {
            callback(SwitchState.LEFT);
          },
          child: Text(left, style: TextStyle(color: state == SwitchState.LEFT ? Colors.white : Colors.black)),
        ),
        RaisedButton(
          color: state == SwitchState.RIGHT ? OvguColor.primary : OvguColor.secondary,
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(15))
          ),
          onPressed: () {
            callback(SwitchState.RIGHT);
          },
          child: Text(right, style: TextStyle(color: state == SwitchState.RIGHT ? Colors.white : Colors.black)),
        )
      ],
    );
  }
}
