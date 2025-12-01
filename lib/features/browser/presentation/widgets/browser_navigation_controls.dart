import 'package:flutter/material.dart';

/// Browser Navigation Controls Widget
class BrowserNavigationControls extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onForward;
  final VoidCallback? onRefresh;
  final bool canGoBack;
  final bool canGoForward;

  const BrowserNavigationControls({
    super.key,
    this.onBack,
    this.onForward,
    this.onRefresh,
    this.canGoBack = false,
    this.canGoForward = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: canGoBack ? onBack : null,
            tooltip: 'Go Back',
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: canGoForward ? onForward : null,
            tooltip: 'Go Forward',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: onRefresh,
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }
}

