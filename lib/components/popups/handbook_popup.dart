import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/pdf_bookmark.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/ui.dart';

class HandbookPopup extends StatelessWidget {

  final List<PdfBookmark> bookmarks;
  final IntCallback callback;

  const HandbookPopup({required this.bookmarks, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10),
              child: Text(t.popups.handbook.title, style: TextStyle(color: OvguColor.primary, fontSize: 20, fontWeight: FontWeight.bold)),
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
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 20),
            physics: Adaptive.getScrollPhysics(),
            children: bookmarks.map((bookmark) {
              return InkWell(
                onTap: () {
                  callback(bookmark.page);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(child: Text(bookmark.name, style: TextStyle(fontSize: 16))),
                      SizedBox(width: 10),
                      Text(t.popups.handbook.page(page: bookmark.page), style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
