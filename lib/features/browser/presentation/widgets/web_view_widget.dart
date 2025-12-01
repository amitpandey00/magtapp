import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'url_launcher_stub.dart' if (dart.library.html) 'url_launcher_web.dart';

/// WebView Widget with InAppWebView (Mobile only)
class WebViewWidget extends StatefulWidget {
  final String initialUrl;
  final Function(InAppWebViewController)? onWebViewCreated;
  final Function(InAppWebViewController, Uri?)? onLoadStart;
  final Function(InAppWebViewController, Uri?)? onLoadStop;
  final Function(InAppWebViewController, int)? onProgressChanged;
  final Function(InAppWebViewController, Uri?, String)? onTitleChanged;
  final Function(InAppWebViewController, WebResourceRequest, WebResourceError)? onLoadError;
  final Function(DownloadStartRequest)? onDownloadStartRequest;

  const WebViewWidget({super.key, required this.initialUrl, this.onWebViewCreated, this.onLoadStart, this.onLoadStop, this.onProgressChanged, this.onTitleChanged, this.onLoadError, this.onDownloadStartRequest});

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  InAppWebViewController? _webViewController;
  PullToRefreshController? _pullToRefreshController;

  @override
  void initState() {
    super.initState();

    // Only initialize pull-to-refresh on mobile platforms
    if (!kIsWeb) {
      _pullToRefreshController = PullToRefreshController(
        settings: PullToRefreshSettings(color: Colors.blue),
        onRefresh: () async {
          await _webViewController?.reload();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Web platform - use HtmlElementView with iframe
    if (kIsWeb) {
      return _WebIframeView(url: widget.initialUrl);
    }

    // Mobile platform - use InAppWebView
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(widget.initialUrl)),
      initialSettings: InAppWebViewSettings(useShouldOverrideUrlLoading: true, mediaPlaybackRequiresUserGesture: false, allowsInlineMediaPlayback: true, iframeAllow: "camera; microphone", iframeAllowFullscreen: true, javaScriptEnabled: true, javaScriptCanOpenWindowsAutomatically: true, useOnDownloadStart: true, supportZoom: true, builtInZoomControls: true, displayZoomControls: false),
      pullToRefreshController: _pullToRefreshController,
      onWebViewCreated: (controller) {
        _webViewController = controller;
        widget.onWebViewCreated?.call(controller);
      },
      onLoadStart: (controller, url) {
        widget.onLoadStart?.call(controller, url);
      },
      onLoadStop: (controller, url) async {
        await _pullToRefreshController?.endRefreshing();
        widget.onLoadStop?.call(controller, url);
      },
      onProgressChanged: (controller, progress) {
        if (progress == 100) {
          _pullToRefreshController?.endRefreshing();
        }
        widget.onProgressChanged?.call(controller, progress);
      },
      onTitleChanged: (controller, title) {
        widget.onTitleChanged?.call(controller, null, title ?? '');
      },
      onReceivedError: (controller, request, error) {
        _pullToRefreshController?.endRefreshing();
        widget.onLoadError?.call(controller, request, error);
      },
      onDownloadStartRequest: (controller, downloadStartRequest) {
        widget.onDownloadStartRequest?.call(downloadStartRequest);
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        return NavigationActionPolicy.ALLOW;
      },
    );
  }

  @override
  void dispose() {
    _webViewController = null;
    super.dispose();
  }
}

/// Web-specific iframe view
class _WebIframeView extends StatefulWidget {
  final String url;

  const _WebIframeView({required this.url});

  @override
  State<_WebIframeView> createState() => _WebIframeViewState();
}

class _WebIframeViewState extends State<_WebIframeView> {
  @override
  Widget build(BuildContext context) {
    // For web platform, we'll use a simple container with a message
    // and provide a link to open in new tab
    // Note: Direct iframe embedding has CORS limitations
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.open_in_browser, size: 80, color: Colors.blue[400]),
              const SizedBox(height: 24),
              Text('Web Browser', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('Click the button below to open this page in a new browser tab.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SelectableText(widget.url, style: const TextStyle(fontFamily: 'monospace', fontSize: 14)),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Open URL in new tab using dart:html
                  _openInNewTab(widget.url);
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open in New Tab'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
              ),
              const SizedBox(height: 16),
              Text(
                'Note: Due to browser security restrictions, embedded browsing is limited on web platform.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openInNewTab(String url) {
    if (kIsWeb) {
      openUrlInNewTab(url);
    }
  }
}
