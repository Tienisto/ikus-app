import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:ikus_app/model/pdf_bookmark.dart';

class HandbookService {

  static const String URL = 'https://stephaneum.de/vertretungsplan.pdf';

  static List<PdfBookmark> _bookmarks = [
    PdfBookmark("1. Vorhandene Infos nach Zusendung der Immatrikulationsbescheinigung", 4),
    PdfBookmark("2. First Steps", 5),
    PdfBookmark("3. Prüfungsrelevantes", 16),
    PdfBookmark("4. Ansprechpartner", 19)
  ];

  static Future<Uint8List> getPDF() async {
    return null;
    http.Response response = await http.get(
      'https://stephaneum.de/vertretungsplan.pdf',
    );
    return response.bodyBytes;
  }

  static Future<List<PdfBookmark>> getBookmarks() async {
    return _bookmarks;
  }
}