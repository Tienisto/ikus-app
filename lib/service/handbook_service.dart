import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/pdf_bookmark.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';

class HandbookService implements SyncableService {

  static final HandbookService _instance = _init();
  static HandbookService get instance => _instance;

  DateTime _lastUpdate;
  List<PdfBookmark> _bookmarks;
  Uint8List _bytes;

  static HandbookService _init() {
    HandbookService service = HandbookService();

    service._bookmarks = [
      PdfBookmark(page: 4, name: "1. Vorhandene Infos nach Zusendung der Immatrikulationsbescheinigung"),
      PdfBookmark(page: 7, name: "2. First Steps"),
      PdfBookmark(page: 11, name: "3. Prüfungsrelevantes"),
      PdfBookmark(page: 14, name: "4. Ansprechpartner")
    ];

    service._bytes = Uint8List.fromList([]);

    service._lastUpdate = DateTime(2020, 8, 24, 13, 12);
    return service;
  }

  @override
  String getName() => t.main.settings.syncItems.handbook;

  @override
  Future<void> sync() async {

    String handbookUrl = ApiService.getHandbookUrl(LocaleSettings.currentLocale);
    Response responsePDF = await ApiService.getCacheOrFetch(handbookUrl);

    if (responsePDF.statusCode != 200)
      return;

    _bytes = responsePDF.bodyBytes;

    Response response = await ApiService.getCacheOrFetch('handbook-bookmarks', LocaleSettings.currentLocale);
    List<dynamic> list = jsonDecode(response.body);
    _bookmarks = list.map((bookmark) => PdfBookmark.fromMap(bookmark)).toList();
    _lastUpdate = DateTime.now();
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  Uint8List getPDF() {
    return _bytes;
  }

  List<PdfBookmark> getBookmarks() {
    return _bookmarks;
  }
}