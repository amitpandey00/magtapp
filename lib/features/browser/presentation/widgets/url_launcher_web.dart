// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Open URL in new browser tab (Web only)
void openUrlInNewTab(String url) {
  html.window.open(url, '_blank');
}

