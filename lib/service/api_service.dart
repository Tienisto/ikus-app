import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:ikus_app/model/api_data.dart';
import 'package:ikus_app/service/jwt_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:intl/intl.dart';

/// manages data from the server
/// e.g. raw json, pdfs, images
class ApiService {

  static String get URL => SettingsService.instance.getDevServer() ? 'https://ikus.tienisto.com/api/public' : 'https://welcome-app.farafin.de/api/public';
  static final DateTime FALLBACK_TIME = DateTime(2020, 8, 1);
  static final DateFormat _lastModifiedFormatter = DateFormat("E, dd MMM yyyy HH:mm:ss 'GMT'", 'en');

  static String getFileUrl(String fileName) {
    return '$URL/file/$fileName';
  }

  static Future<ApiData<String>> getCacheOrFetchString({String route, String locale, bool useCacheOnly, fallback}) async {
    Response response;

    if (!useCacheOnly) {
      try {
        response = await get('$URL/$route?locale=${locale.toUpperCase()}');
        print('[${response.statusCode}] $route');
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

  static Future<ApiData<Uint8List>> getCacheOrFetchBinary({String route, bool useCacheOnly, fallback}) async {
    Response response;

    Box cacheBox = Hive.box<Uint8List>('api_binary');
    Box timestampBox = Hive.box<DateTime>('last_sync');
    String boxKey = 'api_binary/$route';
    DateTime timestamp = timestampBox.get(boxKey) ?? FALLBACK_TIME;

    if (!useCacheOnly) {
      try {
        response = await get('$URL/file/$route', headers: {
          'If-Modified-Since': _lastModifiedFormatter.format(timestamp.toUtc())
        });
        print('[${response.statusCode}] $route');
      } catch (_) {
        print('failed to fetch $route');
      }
    }

    if (response != null && response.statusCode == 200) {
      DateTime timestamp = DateTime.now();
      cacheBox.put(boxKey, response.bodyBytes); // save to cache
      timestampBox.put(boxKey, timestamp); // save timestamp
      return ApiData(data: response.bodyBytes, timestamp: timestamp);
    } else {
      Uint8List cachedData = cacheBox.get(boxKey);
      if (cachedData != null) {
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

  static Future<void> appStart(BuildContext context) async {
    TargetPlatform platform = Theme.of(context).platform;
    String deviceId = Hive.box('device_id').get('device_id');

    Map<String, dynamic> body = {
      'token': JwtService.generateToken(),
      'deviceId': deviceId,
      'platform': platform == TargetPlatform.iOS ? 'IOS' : 'ANDROID',
    };

    await post(
      '$URL/start',
      headers: {'content-type': 'application/json'},
      body: json.encode(body)
    );
  }
}