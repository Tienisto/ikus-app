import 'dart:convert';
import 'dart:typed_data';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/api_data.dart';
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
  Future<void> sync({bool useCache}) async {
    String handbookUrl = getHandbookUrl(LocaleSettings.currentLocale, false);
    ApiData pdfData = await ApiService.getCacheOrFetchBinary(
      route: handbookUrl,
      useCache: useCache,
      fallback: Uint8List.fromList([])
    );

    ApiData bookmarksData = await ApiService.getCacheOrFetchString(
        route: 'handbook-bookmarks',
        locale: LocaleSettings.currentLocale,
        useCache: useCache,
        fallback: []
    );

    List<dynamic> list = jsonDecode(bookmarksData.data);

    _bookmarks = list.map((bookmark) => PdfBookmark.fromMap(bookmark)).toList();
    _bytes = pdfData.data;
    _lastUpdate = pdfData.timestamp;
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

  String getHandbookUrl(String locale, bool absolute) {
    if (absolute)
      return ApiService.getFileUrl('handbook/${locale.toLowerCase()}.pdf');
    else
      return 'handbook/${locale.toLowerCase()}.pdf';
  }
}