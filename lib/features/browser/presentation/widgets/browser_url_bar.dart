import 'package:flutter/material.dart';
import '../../../../core/utils/validators.dart';

/// Browser URL Bar Widget
class BrowserUrlBar extends StatefulWidget {
  final String? initialUrl;
  final Function(String) onSubmitted;
  final VoidCallback? onRefresh;
  final bool isLoading;

  const BrowserUrlBar({
    super.key,
    this.initialUrl,
    required this.onSubmitted,
    this.onRefresh,
    this.isLoading = false,
  });

  @override
  State<BrowserUrlBar> createState() => _BrowserUrlBarState();
}

class _BrowserUrlBarState extends State<BrowserUrlBar> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialUrl);
  }

  @override
  void didUpdateWidget(BrowserUrlBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialUrl != oldWidget.initialUrl && !_focusNode.hasFocus) {
      _controller.text = widget.initialUrl ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    String url;
    if (Validators.isSearchQuery(input)) {
      url = Validators.searchQueryToUrl(input);
    } else {
      url = Validators.formatUrl(input);
    }

    widget.onSubmitted(url);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Enter URL or search...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: widget.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              textInputAction: TextInputAction.go,
              onSubmitted: (_) => _handleSubmit(),
            ),
          ),
          if (widget.onRefresh != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: widget.onRefresh,
              tooltip: 'Refresh',
            ),
          ],
        ],
      ),
    );
  }
}

