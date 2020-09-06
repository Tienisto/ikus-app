import 'package:http/http.dart';

class ApiService {

  static const String URL = 'https://ikus.tienisto.com/api';

  static Future<Response> getOrCached(String route, String locale) {
    return get('$URL/$route?locale=${locale.toUpperCase()}');
  }
}