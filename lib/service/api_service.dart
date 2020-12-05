import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:ikus_app/constants.dart';
import 'package:ikus_app/init.dart';
import 'package:ikus_app/model/data_with_timestamp.dart';
import 'package:ikus_app/service/app_config_service.dart';
import 'package:ikus_app/service/jwt_service.dart';
import 'package:ikus_app/service/persistent_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:intl/intl.dart';

/// manages data from the server
/// e.g. raw json, pdfs, images
class ApiService {

  static String get URL => SettingsService.instance.getDevServer() ? Constants.apiUrlDebug : Constants.apiUrlLive;
  static final DateTime FALLBACK_TIME = DateTime(2020, 8, 1);
  static final DateFormat _lastModifiedFormatter = DateFormat("E, dd MMM yyyy HH:mm:ss 'GMT'", 'en');

  static String getFileUrl(String fileName) {
    return '$URL/file/$fileName';
  }

  /// fetch batch route (no cache mechanism)
  /// preparation for [getCacheOrFetchString] with useJSON
  static Future<String> fetchBatchString({String locale, List<String> routes}) async {

    assert(routes.isNotEmpty, 'routes must not be empty');

    String routesQuery = routes.join(',');
    String url = '$URL/combined?locale=${locale.toUpperCase()}&routes=$routesQuery';
    try {

      Response response = await get(url);
      print('[${response.statusCode}] $url');

      if (response.statusCode == 200)
       return utf8.decode(response.bodyBytes);

    } catch (_) {}

    print('failed to fetch $url');
    return null;
  }

  /// uses network or given data and caches it
  /// set [useJSON] for batch update (prefetch in an earlier step)
  /// 1: use json from [useJSON] if [useJSON] is not null
  /// 2: fetch route if [useNetwork] is true
  /// 3: use cache
  /// 4: use [fallback]
  static Future<DataWithTimestamp<String>> getCacheOrFetchString({String route, String locale, String useJSON, bool useNetwork, fallback}) async {

    final String key = 'api_json/$route';

    if (useJSON != null) {
      DataWithTimestamp<String> newData = DataWithTimestamp(data: useJSON, timestamp: DateTime.now());
      await PersistentService.instance.setApiJson(key, newData);
      return newData;
    }

    Response response;
    if ((!Init.postInitFinished || AppConfigService.instance.isCompatibleWithApi() != false) && useNetwork) {
      try {
        response = await get('$URL/$route?locale=${locale.toUpperCase()}');
        print('[${response.statusCode}] $route');
      } catch (_) {
        print('failed to fetch $route');
      }
    }

    if (response != null && response.statusCode == 200) {
      DataWithTimestamp<String> newData = DataWithTimestamp(data: utf8.decode(response.bodyBytes), timestamp: DateTime.now());
      await PersistentService.instance.setApiJson(key, newData);
      return newData;
    } else {
      return PersistentService.instance.getApiJson(key) ?? DataWithTimestamp(data: jsonEncode(fallback), timestamp: FALLBACK_TIME);
    }
  }

  /// uses network or given data and caches it
  /// 1: fetch route if [useNetwork] is true
  /// 2: use cache
  /// 3: use [fallback]
  static Future<DataWithTimestamp<Uint8List>> getCacheOrFetchBinary({String route, bool useNetwork, fallback}) async {
    Response response;
    final String key = 'api_binary/$route';

    if ((!Init.postInitFinished || AppConfigService.instance.isCompatibleWithApi() != false) && useNetwork) {
      try {
        DateTime timestamp = PersistentService.instance.getApiTimestamp(key) ?? FALLBACK_TIME;
        response = await get('$URL/file/$route', headers: {
          'If-Modified-Since': _lastModifiedFormatter.format(timestamp.toUtc())
        });
        print('[${response.statusCode}] $route');
      } catch (_) {
        print('failed to fetch $route');
      }
    }

    if (response != null && response.statusCode == 200) {
      DataWithTimestamp<Uint8List> newData = DataWithTimestamp(data: response.bodyBytes, timestamp: DateTime.now());
      await PersistentService.instance.setApiBinary(key, newData);
      return newData;
    } else {
      return PersistentService.instance.getApiBinary(key) ?? DataWithTimestamp(data: fallback, timestamp: FALLBACK_TIME);
    }
  }

  static Future<void> appStart() async {
    String deviceId = PersistentService.instance.getDeviceId();

    Map<String, dynamic> body = {
      'token': JwtService.generateToken(),
      'deviceId': deviceId,
      'platform': Platform.isIOS ? 'IOS' : 'ANDROID',
    };

    await post(
      '$URL/start',
      headers: {'content-type': 'application/json'},
      body: json.encode(body)
    );
  }
}