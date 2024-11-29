import 'dart:convert';
import 'dart:typed_data';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/local/data_with_timestamp.dart';
import 'package:ikus_app/model/pdf_bookmark.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/callbacks.dart';

class HandbookService implements SyncableService {

  static final HandbookService _instance = HandbookService();
  static HandbookService get instance => _instance;

  late DateTime _lastUpdate;
  late List<PdfBookmark> _bookmarks;
  late Uint8List _bytes;

  @override
  String id = 'HANDBOOK';

  @override
  String getDescription() => t.sync.items.handbook;

  // useJSON applies only to the rest route
  @override
  Future<void> sync({required bool useNetwork, String? useJSON, bool showNotifications = false, AddFutureCallback? onBatchFinished}) async {
    String handbookUrl = getHandbookUrl(LocaleSettings.currentLocale.languageTag, false);
    DataWithTimestamp pdfData = await ApiService.getCacheOrFetchBinary(
      route: handbookUrl,
      useNetwork: useNetwork,
      fallback: Uint8List.fromList([])
    );

    DataWithTimestamp bookmarksData = await ApiService.getCacheOrFetchString(
        route: 'handbook-bookmarks',
        locale: LocaleSettings.currentLocale.languageTag,
        useJSON: useJSON,
        useNetwork: useNetwork,
        fallback: []
    );

    List<dynamic> list = jsonDecode(bookmarksData.data);

    _bookmarks = list.map((bookmark) => PdfBookmark.fromMap(bookmark)).toList();
    _bytes = pdfData.data;

    // take the newer one
    _lastUpdate = pdfData.timestamp.isAfter(bookmarksData.timestamp) ? pdfData.timestamp : bookmarksData.timestamp;
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  @override
  Duration maxAge = Duration(days: 3);

  @override
  String batchKey = 'HANDBOOK_BOOKMARKS'; // applies only to json route

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