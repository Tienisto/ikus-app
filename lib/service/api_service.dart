import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:ikus_app/model/api_data.dart';

class ApiService {

  static const String URL = 'https://ikus.tienisto.com/api/public';

  static String getFileUrl(String fileName, [bool absolute = true]) {
    if (absolute)
      return '$URL/file/$fileName';
    else
      return 'file/$fileName';
  }

  static Future<ApiData<String>> getCacheOrFetchString({String route, String locale, fallback}) async {
    Response response;

    try {
      response = await get('$URL/$route?locale=${locale.toUpperCase()}');
    } catch (_) {
      print('failed to fetch $route');
    }

    if (response != null && response.statusCode == 200) {
      return ApiData(data: response.body, cached: false);
    } else {
      return ApiData(data: jsonEncode(fallback), cached: true); // TODO: hive
    }
  }

  static Future<ApiData<Uint8List>> getCacheOrFetchBinary({String route, fallback}) async {
    Response response;

    try {
      response = await get('$URL/file/$route');
    } catch (_) {
      print('failed to fetch $route');
    }

    if (response != null && response.statusCode == 200) {
      return ApiData(data: response.bodyBytes, cached: false);
    } else {
      return ApiData(data: fallback, cached: true); // TODO: hive
    }
  }
}