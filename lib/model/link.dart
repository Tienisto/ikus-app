class Link {

  final String url;
  final String info;

  Link(this.url, this.info);

  String get urlNoHttp {
    return url.replaceAll('https://', '').replaceAll('http://', '');
  }
}