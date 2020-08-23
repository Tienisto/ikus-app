import 'dart:typed_data';
import 'package:http/http.dart' as http;

class HandbookService {


  static Future<Uint8List> getPDF() async {
    return null;
    http.Response response = await http.get(
      'https://stephaneum.de/vertretungsplan.pdf',
    );
    return response.bodyBytes;
  }
}