import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ikus_app/utility/open_browser.dart';

/// wrapper for html-widget with default settings
class HtmlView extends StatelessWidget {

  final String html;
  final EdgeInsets padding;

  const HtmlView({required this.html, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Html(
        data: html,
        style: {
          "body": Style(fontSize: FontSize.large, padding: HtmlPaddings.zero), // make text bigger
        },
        onLinkTap: (String? url, attributes, element) async {
          if (url != null) {
            openBrowser(url);
          }
        },
      ),
    );
  }
}
