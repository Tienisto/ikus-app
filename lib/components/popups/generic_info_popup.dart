import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/utility/ui.dart';

class GenericInfoPopup extends StatelessWidget {

  final String title;
  final Widget child;

  const GenericInfoPopup({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10),
              child: Text(title, style: TextStyle(color: OvguColor.primary, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            OvguButton(
              flat: true,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              callback: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close),
            )
          ],
        ),
        Expanded(
          child: child,
        )
      ],
    );
  }
}
