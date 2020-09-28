import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:ikus_app/model/api_data.dart';

class ApiService {

  static const String URL = 'https://ikus.tienisto.com/api/public';
  static final DateTime FALLBACK_TIME = DateTime(2020, 8, 1);

  static String getFileUrl(String fileName) {
    return '$URL/file/$fileName';
  }

  static Future<ApiData<String>> getCacheOrFetchString({String route, String locale, bool useCache, fallback}) async {
    Response response;

    if (!useCache) {
      try {
        response = await get('$URL/$route?locale=${locale.toUpperCase()}');
      } catch (_) {
        print('failed to fetch $route');
      }
    }

    Box cacheBox = Hive.box<String>('api_json');
    Box timestampBox = Hive.box<DateTime>('last_sync');
    String boxKey = 'api_json/$route';

    if (response != null && response.statusCode == 200) {
      DateTime timestamp = DateTime.now();
      cacheBox.put(boxKey, response.body); // save to cache
      timestampBox.put(boxKey, timestamp); // save timestamp
      return ApiData(data: response.body, timestamp: timestamp);
    } else {
      String cachedData = cacheBox.get(boxKey);
      if (cachedData != null) {
        DateTime timestamp = timestampBox.get(boxKey) ?? FALLBACK_TIME;
        return ApiData(data: cachedData, timestamp: timestamp); // cached data
      } else {
        return ApiData(data: jsonEncode(fallback), timestamp: FALLBACK_TIME); // fallback data
      }
    }
  }

  static Future<ApiData<Uint8List>> getCacheOrFetchBinary({String route, bool useCache, fallback}) async {
    Response response;

    if (!useCache) {
      try {
        response = await get('$URL/file/$route');
      } catch (_) {
        print('failed to fetch $route');
      }
    }

    Box cacheBox = Hive.box<Uint8List>('api_binary');
    Box timestampBox = Hive.box<DateTime>('last_sync');
    String boxKey = 'api_binary/$route';

    if (response != null && response.statusCode == 200) {
      DateTime timestamp = DateTime.now();
      cacheBox.put(boxKey, response.bodyBytes); // save to cache
      timestampBox.put(boxKey, timestamp); // save timestamp
      return ApiData(data: response.bodyBytes, timestamp: timestamp);
    } else {
      Uint8List cachedData = cacheBox.get(boxKey);
      if (cachedData != null) {
        DateTime timestamp = timestampBox.get(boxKey) ?? FALLBACK_TIME;
        return ApiData(data: cachedData, timestamp: timestamp); // cached data
      } else {
        return ApiData(data: fallback, timestamp: FALLBACK_TIME); // fallback data
      }
    }
  }

  static Future<void> clearCache() async {
    Box jsonBox = Hive.box<String>('api_json');
    Box binaryBox = Hive.box<Uint8List>('api_binary');
    Box timestampBox = Hive.box<DateTime>('last_sync');
    await jsonBox.clear();
    await binaryBox.clear();
    await timestampBox.clear();
  }
}