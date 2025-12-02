import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../../core/models/browser_tab.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/browser_state.dart';
import '../providers/download_provider.dart';
import '../widgets/browser_url_bar.dart';
import '../widgets/browser_navigation_controls.dart';
import '../widgets/web_view_widget.dart';

/// Browser Screen - Main browser interface
class BrowserScreen extends ConsumerStatefulWidget {
  const BrowserScreen({super.key});

  @override
  ConsumerState<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends ConsumerState<BrowserScreen> {
  InAppWebViewController? _webViewController;
  bool _canGoBack = false;
  bool _canGoForward = false;
  String _currentUrl = 'https://www.google.com';
  String _currentTitle = 'Google';
  bool _hasInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get URL from route arguments if provided
    if (!_hasInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        _currentUrl = args;
        _currentTitle = _getTitleFromUrl(args);
      }
      _hasInitialized = true;

      // Create initial tab after getting arguments
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _createInitialTab();
      });
    }
  }

  String _getTitleFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceAll('www.', '');
    } catch (e) {
      return 'New Tab';
    }
  }

  void _createInitialTab() {
    final browserNotifier = ref.read(browserProvider.notifier);
    final browserState = ref.read(browserProvider);

    if (browserState.tabs.isEmpty) {
      // Only create a new tab if none exist
      final initialTab = BrowserTab(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        url: _currentUrl,
        title: _currentTitle,
        createdAt: DateTime.now(),
        lastAccessedAt: DateTime.now(),
        isActive: true,
      );
      browserNotifier.addTab(initialTab);
    } else {
      // Use the active tab's URL
      final activeTab = browserState.activeTab;
      if (activeTab != null) {
        setState(() {
          _currentUrl = activeTab.url;
          _currentTitle = activeTab.title;
        });
      }
    }
  }

  Future<void> _updateNavigationState() async {
    if (_webViewController != null) {
      _canGoBack = await _webViewController!.canGoBack();
      _canGoForward = await _webViewController!.canGoForward();
      setState(() {});
    }
  }

  void _loadUrl(String url) {
    _webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
  }

  void _goBack() async {
    if (await _webViewController?.canGoBack() ?? false) {
      await _webViewController?.goBack();
    }
  }

  void _goForward() async {
    if (await _webViewController?.canGoForward() ?? false) {
      await _webViewController?.goForward();
    }
  }

  void _refresh() {
    _webViewController?.reload();
  }

  @override
  Widget build(BuildContext context) {
    final browserState = ref.watch(browserProvider);
    final activeTab = browserState.activeTab;

    if (activeTab == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentTitle.isEmpty ? AppStrings.appName : _currentTitle,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final newTab = BrowserTab(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                url: 'https://www.google.com',
                title: 'New Tab',
                createdAt: DateTime.now(),
                lastAccessedAt: DateTime.now(),
                isActive: true,
              );
              ref.read(browserProvider.notifier).addTab(newTab);
            },
            tooltip: 'New Tab',
          ),
          IconButton(
            icon: Badge(
              label: Text('${browserState.tabCount}'),
              child: const Icon(Icons.tab),
            ),
            onPressed: () {
              // Navigate to tab manager (index 2 in bottom navigation)
              // This will be handled by the main scaffold
            },
            tooltip: 'Tabs',
          ),
        ],
      ),
      body: Column(
        children: [
          BrowserUrlBar(
            initialUrl: _currentUrl,
            onSubmitted: _loadUrl,
            onRefresh: _refresh,
            isLoading: browserState.isLoading,
          ),
          if (browserState.progress > 0 && browserState.progress < 1)
            LinearProgressIndicator(value: browserState.progress, minHeight: 2),
          BrowserNavigationControls(
            onBack: _goBack,
            onForward: _goForward,
            onRefresh: _refresh,
            canGoBack: _canGoBack,
            canGoForward: _canGoForward,
          ),
          Expanded(
            child: WebViewWidget(
              key: ValueKey(activeTab.id),
              initialUrl: activeTab.url,
              onWebViewCreated: (controller) {
                _webViewController = controller;
                _updateNavigationState();
              },
              onLoadStart: (controller, url) {
                ref.read(browserProvider.notifier).setLoading(true);
                ref.read(browserProvider.notifier).setProgress(0.0);
              },
              onLoadStop: (controller, url) async {
                ref.read(browserProvider.notifier).setLoading(false);
                ref.read(browserProvider.notifier).setProgress(1.0);

                final currentUrl = url?.toString() ?? activeTab.url;
                final title = await controller.getTitle() ?? '';

                setState(() {
                  _currentUrl = currentUrl;
                  _currentTitle = title;
                });

                ref
                    .read(browserProvider.notifier)
                    .updateTabUrl(activeTab.id, currentUrl, title);

                await _updateNavigationState();
              },
              onProgressChanged: (controller, progress) {
                ref.read(browserProvider.notifier).setProgress(progress / 100);
              },
              onTitleChanged: (controller, url, title) {
                setState(() {
                  _currentTitle = title;
                });
              },
              onLoadError: (controller, request, error) {
                ref.read(browserProvider.notifier).setLoading(false);
                ref.read(browserProvider.notifier).setError(error.description);
              },
              onDownloadStartRequest: (downloadRequest) async {
                final downloadService = ref.read(downloadServiceProvider);
                final downloadNotifier = ref.read(downloadProvider.notifier);
                final messenger = ScaffoldMessenger.of(context);

                final fileName =
                    downloadRequest.suggestedFilename ?? 'download';
                downloadNotifier.startDownload(fileName);

                messenger.showSnackBar(
                  SnackBar(content: Text('Downloading $fileName...')),
                );

                final document = await downloadService.downloadFile(
                  downloadRequest,
                  onProgress: (received, total) {
                    final progress = (received / total * 100);
                    downloadNotifier.updateProgress(progress);
                  },
                );

                if (document != null) {
                  downloadNotifier.completeDownload();
                  messenger.showSnackBar(
                    SnackBar(content: Text('Downloaded: ${document.name}')),
                  );
                } else {
                  downloadNotifier.setError('Download failed');
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Download failed')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
