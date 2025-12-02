import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../../core/utils/logger.dart';

/// JavaScript Bridge for WebView interactions
class JavaScriptBridge {
  /// Extract all text content from the current page
  static Future<String?> extractPageText(InAppWebViewController controller) async {
    try {
      final result = await controller.evaluateJavascript(
        source: '''
        (function() {
          // Remove script and style elements
          var scripts = document.querySelectorAll('script, style, noscript');
          scripts.forEach(function(el) { el.remove(); });
          
          // Get body text content
          var text = document.body.innerText || document.body.textContent || '';
          
          // Clean up whitespace
          text = text.replace(/\\s+/g, ' ').trim();
          
          return text;
        })();
      ''',
      );

      return result?.toString();
    } catch (e) {
      Logger.error('Error extracting page text', tag: 'JavaScriptBridge', error: e);
      return null;
    }
  }

  /// Extract main content from the page (article, main, or body)
  static Future<String?> extractMainContent(InAppWebViewController controller) async {
    try {
      final result = await controller.evaluateJavascript(
        source: '''
        (function() {
          // Try to find main content area
          var mainContent = document.querySelector('article') || 
                           document.querySelector('main') || 
                           document.querySelector('[role="main"]') ||
                           document.body;
          
          // Remove unwanted elements
          var unwanted = mainContent.querySelectorAll('script, style, noscript, nav, header, footer, aside, .ad, .advertisement');
          unwanted.forEach(function(el) { el.remove(); });
          
          // Get text content
          var text = mainContent.innerText || mainContent.textContent || '';
          
          // Clean up whitespace
          text = text.replace(/\\s+/g, ' ').trim();
          
          return text;
        })();
      ''',
      );

      return result?.toString();
    } catch (e) {
      Logger.error('Error extracting main content', tag: 'JavaScriptBridge', error: e);
      return null;
    }
  }

  /// Get page metadata (title, description, keywords)
  static Future<Map<String, String>> getPageMetadata(InAppWebViewController controller) async {
    try {
      final result = await controller.evaluateJavascript(
        source: '''
        (function() {
          var title = document.title || '';
          var description = '';
          var keywords = '';
          
          var metaDesc = document.querySelector('meta[name="description"]');
          if (metaDesc) {
            description = metaDesc.getAttribute('content') || '';
          }
          
          var metaKeywords = document.querySelector('meta[name="keywords"]');
          if (metaKeywords) {
            keywords = metaKeywords.getAttribute('content') || '';
          }
          
          return {
            title: title,
            description: description,
            keywords: keywords
          };
        })();
      ''',
      );

      if (result is Map) {
        return {'title': result['title']?.toString() ?? '', 'description': result['description']?.toString() ?? '', 'keywords': result['keywords']?.toString() ?? ''};
      }

      return {};
    } catch (e) {
      Logger.error('Error getting page metadata', tag: 'JavaScriptBridge', error: e);
      return {};
    }
  }

  /// Highlight text on the page
  static Future<void> highlightText(InAppWebViewController controller, String searchText) async {
    try {
      await controller.evaluateJavascript(
        source:
            '''
        (function() {
          var searchText = "$searchText";
          var regex = new RegExp(searchText, 'gi');
          
          function highlightNode(node) {
            if (node.nodeType === 3) { // Text node
              var text = node.nodeValue;
              if (regex.test(text)) {
                var span = document.createElement('span');
                span.innerHTML = text.replace(regex, '<mark>\$&</mark>');
                node.parentNode.replaceChild(span, node);
              }
            } else if (node.nodeType === 1 && node.nodeName !== 'SCRIPT' && node.nodeName !== 'STYLE') {
              for (var i = 0; i < node.childNodes.length; i++) {
                highlightNode(node.childNodes[i]);
              }
            }
          }
          
          highlightNode(document.body);
        })();
      ''',
      );
    } catch (e) {
      Logger.error('Error highlighting text', tag: 'JavaScriptBridge', error: e);
    }
  }

  /// Remove all highlights from the page
  static Future<void> removeHighlights(InAppWebViewController controller) async {
    try {
      await controller.evaluateJavascript(
        source: '''
        (function() {
          var marks = document.querySelectorAll('mark');
          marks.forEach(function(mark) {
            var parent = mark.parentNode;
            parent.replaceChild(document.createTextNode(mark.textContent), mark);
            parent.normalize();
          });
        })();
      ''',
      );
    } catch (e) {
      Logger.error('Error removing highlights', tag: 'JavaScriptBridge', error: e);
    }
  }
}
