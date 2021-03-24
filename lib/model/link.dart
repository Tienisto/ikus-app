class Link {

  final String url;
  final String info;

  Link({required this.url, required this.info});

  String get urlNoHttp {
    return url.replaceAll('https://', '').replaceAll('http://', '');
  }

  static Link fromMap(Map<String, dynamic> map) {
    return Link(
        url: map['url'],
        info: map['info'],
    );
  }

  @override
  String toString() {
    return info;
  }
}