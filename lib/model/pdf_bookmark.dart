class PdfBookmark {

  final int page;
  final String name;

  PdfBookmark({this.page, this.name});

  static PdfBookmark fromMap(Map<String, dynamic> map) {
    return PdfBookmark(
        page: map['page'],
        name: map['name']
    );
  }

  @override
  String toString() {
    return '$name ($page)';
  }
}