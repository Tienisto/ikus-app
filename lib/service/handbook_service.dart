import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/pdf_bookmark.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/globals.dart';

class HandbookService implements SyncableService {

  static const String URL = 'https://stephaneum.de/vertretungsplan.pdf';

  static final HandbookService _instance = _init();
  static HandbookService get instance => _instance;

  DateTime _lastUpdate;
  List<PdfBookmark> _bookmarks;

  static HandbookService _init() {
    HandbookService service = HandbookService();

    service._bookmarks = [
      PdfBookmark("1. Vorhandene Infos nach Zusendung der Immatrikulationsbescheinigung", 4),
      PdfBookmark("2. First Steps", 5),
      PdfBookmark("3. Prüfungsrelevantes", 16),
      PdfBookmark("4. Ansprechpartner", 19)
    ];

    service._lastUpdate = DateTime(2020, 8, 24, 13, 12);
    return service;
  }

  @override
  String getName() => t.main.settings.syncItems.handbook;

  @override
  Future<void> sync() async {
    await sleep(500);
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  Future<Uint8List> getPDF() async {
    return null;
    http.Response response = await http.get(
      'https://stephaneum.de/vertretungsplan.pdf',
    );
    return response.bodyBytes;
  }

  List<PdfBookmark> getBookmarks() {
    return _bookmarks;
  }
}