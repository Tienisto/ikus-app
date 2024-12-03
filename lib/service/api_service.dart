// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:ikus_app/gen/env.g.dart';
import 'package:ikus_app/init.dart';
import 'package:ikus_app/model/local/data_with_timestamp.dart';
import 'package:ikus_app/service/app_config_service.dart';
import 'package:ikus_app/service/persistent_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/utility/crypto.dart';
import 'package:intl/intl.dart';

/// manages data from the server
/// e.g. raw json, pdfs, images
class ApiService {

  static const String LOG_NAME = 'API';
  static String get URL => SettingsService.instance.getDevServer() ? Env.apiDevUrl : Env.apiUrl;
  static final DateTime FALLBACK_TIME = DateTime(2020, 8, 1);
  static final DateFormat _lastModifiedFormatter = DateFormat("E, dd MMM yyyy HH:mm:ss 'GMT'", 'en');

  /// true if last [getCacheOrFetchString] used internet connection
  static bool? usedNetworkOnLastJSONFetch;

  static String getFileUrl(String fileName) {
    return '$URL/file/$fileName';
  }

  /// fetch batch route (no cache mechanism)
  /// preparation for [getCacheOrFetchString] with useJSON
  static Future<String?> fetchBatchString({required String locale, required List<String> routes}) async {
    assert(routes.isNotEmpty, 'routes must not be empty');

    String url = '$URL/batch?locale=${locale.toUpperCase()}&routes=${routes.join(',')}';
    try {

      final response = await http.get(Uri.parse(url));
      log('[${response.statusCode}] $url', name: LOG_NAME);

      if (response.statusCode == 200)
       return utf8.decode(response.bodyBytes);

    } catch (_) {}

    log('failed to fetch $url', name: LOG_NAME);
    return null;
  }

  /// uses network or given data and caches it
  /// set [useJSON] for batch update (prefetch in an earlier step)
  /// 1: use json from [useJSON] if [useJSON] is not null
  /// 2: fetch route if [useNetwork] is true
  /// 3: use cache
  /// 4: use [fallback]
  static Future<DataWithTimestamp<String>> getCacheOrFetchString({required String route, required String locale, String? useJSON, required bool useNetwork, required fallback}) async {

    final String key = 'api_json/$route';

    if (useJSON != null) {
      DataWithTimestamp<String> newData = DataWithTimestamp(data: useJSON, timestamp: DateTime.now());
      await PersistentService.instance.setApiJson(key, newData);
      return newData;
    }

    http.Response? response;
    if ((!Init.postInitFinished || AppConfigService.instance.isCompatibleWithApi() != false) && useNetwork) {
      try {
        response = await http.get(Uri.parse('$URL/$route?locale=${locale.toUpperCase()}'));
        log('[${response.statusCode}] $route', name: LOG_NAME);
        usedNetworkOnLastJSONFetch = true;
      } catch (e) {
        if (e is SocketException) {
          usedNetworkOnLastJSONFetch = false;
        }
        log('failed to fetch $route', name: LOG_NAME);
      }
    }

    if (response != null && response.statusCode == 200) {
      DataWithTimestamp<String> newData = DataWithTimestamp(data: utf8.decode(response.bodyBytes), timestamp: DateTime.now());
      await PersistentService.instance.setApiJson(key, newData);
      return newData;
    } else {
      return await PersistentService.instance.getApiJson(key) ?? DataWithTimestamp(data: jsonEncode(fallback), timestamp: FALLBACK_TIME);
    }
  }

  /// uses network or given data and caches it
  /// 1: fetch route if [useNetwork] is true
  /// 2: use cache
  /// 3: use [fallback]
  static Future<DataWithTimestamp<Uint8List>> getCacheOrFetchBinary({required String route, required bool useNetwork, required fallback}) async {
    http.Response? response;
    final String key = 'api_binary/$route';

    if ((!Init.postInitFinished || AppConfigService.instance.isCompatibleWithApi() != false) && useNetwork) {
      try {
        DateTime timestamp = await PersistentService.instance.getApiTimestamp(key) ?? FALLBACK_TIME;
        response = await http.get(Uri.parse('$URL/file/$route'), headers: {
          'If-Modified-Since': _lastModifiedFormatter.format(timestamp.toUtc())
        });
        log('[${response.statusCode}] $route', name: LOG_NAME);
      } catch (_) {
        log('failed to fetch $route', name: LOG_NAME);
      }
    }

    if (response != null && response.statusCode == 200) {
      DataWithTimestamp<Uint8List> newData = DataWithTimestamp(data: response.bodyBytes, timestamp: DateTime.now());
      await PersistentService.instance.setApiBinary(key, newData);
      return newData;
    } else {
      return await PersistentService.instance.getApiBinary(key) ?? DataWithTimestamp(data: fallback, timestamp: FALLBACK_TIME);
    }
  }

  static Future<void> appStart() async {
    String? deviceId = PersistentService.instance.getDeviceId();

    Map<String, dynamic> body = {
      'token': Crypto.generateToken(),
      'deviceId': deviceId ?? 'unknown',
      'platform': Platform.isIOS ? 'IOS' : 'ANDROID',
    };

    await http.post(
      Uri.parse('$URL/start'),
      headers: {'content-type': 'application/json'},
      body: json.encode(body)
    );
  }

  /// register an event
  /// returns a token if successful, null otherwise
  static Future<String> registerEvent({
    required int eventId,
    required int? matriculationNumber,
    required String? firstName,
    required String? lastName,
    required String? email,
    required String? address,
    required String? country
  }) async {

    final body = {
      'jwt': Crypto.generateToken(),
      'eventId': eventId,
      'matriculationNumber': matriculationNumber,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'address': address,
      'country': country,
    };

    final response = await http.post(
        Uri.parse('$URL/event/register'),
        headers: {'content-type': 'application/json'},
        body: json.encode(body)
    );

    if (response.statusCode != 200) {
      log('register failed (HTTP response: ${response.statusCode}', name: LOG_NAME);
      throw response.statusCode;
    }

    final raw = utf8.decode(response.bodyBytes);
    final obj = json.decode(raw);
    return obj['token'];
  }

  /// deletes an event registration
  /// returns true if successful, otherwise false
  static Future<bool> unregisterEvent({
    required int eventId,
    required String token,
  }) async {
    final body = {
      'jwt': Crypto.generateToken(),
      'eventId': eventId,
      'token': token
    };

    try {
      final response = await http.post(
          Uri.parse('$URL/event/unregister'),
          headers: {'content-type': 'application/json'},
          body: json.encode(body),
      );
      return response.statusCode == 200;
    } catch (_) {
      log('unregister failed', name: LOG_NAME);
      return false;
    }
  }
}