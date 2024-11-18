import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
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
      child: HtmlWidget(
        html,
        textStyle: TextStyle(fontSize: 16),
        onTapUrl: (url) async {
          openBrowser(url);
          return true;
        },
      ),
    );
  }
}
