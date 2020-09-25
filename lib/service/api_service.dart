import 'package:http/http.dart';

class ApiService {

  static const String URL = 'https://ikus.tienisto.com/api/public';

  static String getFileUrl(String fileName) {
    return '$URL/file/$fileName';
  }

  static String getHandbookUrl(String locale, [bool absolute = false]) {
    if(absolute)
      return '$URL/file/handbook/${locale.toLowerCase()}.pdf';
    else
      return 'file/handbook/${locale.toLowerCase()}.pdf';
  }

  static Future<Response> getCacheOrFetch(String route, [String locale]) {
    if (locale == null)
      return get('$URL/$route');
    else
      return get('$URL/$route?locale=${locale.toUpperCase()}');
  }
}