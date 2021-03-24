import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class OvguCardWithHeader extends StatelessWidget {

  final String left;
  final String right;
  final List<Widget>? headerIcons;
  final Widget child;
  final Callback? onTap;

  const OvguCardWithHeader({required this.left, required this.right, required this.child, this.headerIcons, this.onTap});

  @override
  Widget build(BuildContext context) {
    return OvguCard(
      child: InkWell(
        customBorder: OvguPixels.shape,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      height: 25,
                      decoration: BoxDecoration(
                        color: OvguColor.primary,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(OvguPixels.borderRadiusPlain), bottomRight: Radius.circular(OvguPixels.borderRadiusPlain))
                      ),
                      child: FittedBox(
                        // FittedBox scales the text down if it is too large
                        child: Text(left, style: TextStyle(color: Colors.white))
                      )
                    ),
                  ),
                ),
                if (headerIcons != null)
                  ...headerIcons!,
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(right, style: TextStyle(color: OvguColor.secondaryDarken2)),
                )
              ],
            ),
            child
          ],
        ),
      ),
    );
  }
}
