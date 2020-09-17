import 'package:http/http.dart';

class ApiService {

  static const String URL = 'https://ikus.tienisto.com/api/public';

  static String getFileUrl(String fileName) {
    return '$URL/file/$fileName';
  }

  static Future<Response> getCacheOrFetch(String route, String locale) {
    return get('$URL/$route?locale=${locale.toUpperCase()}');
  }
}