import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/service/handbook_service.dart';
import 'package:ikus_app/utility/ui.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class HandbookScreen extends StatefulWidget {
  @override
  _HandbookScreenState createState() => _HandbookScreenState();
}

class _HandbookScreenState extends State<HandbookScreen> {

  final pdfController = PdfController(
    document: HandbookService.getPDF().then((value) {
      if (value != null)
        return PdfDocument.openData(value);
      else
        return PdfDocument.openAsset('assets/pdf/handbook.pdf');
    }),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
        title: Text(t.handbook.title)
      ),
      body: PdfView(
        controller: pdfController,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
