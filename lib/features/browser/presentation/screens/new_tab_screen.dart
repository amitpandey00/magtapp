import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/shortcut.dart';

class NewTabScreen extends ConsumerWidget {
  const NewTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
              child: const Text(
                'magtapp',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.translate), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildShortcutSection('Shopping', Shortcut.getShoppingShortcuts(), context),
                  const SizedBox(height: 24),
                  _buildShortcutSection('News', Shortcut.getNewsShortcuts(), context),
                  const SizedBox(height: 80), // Space for search bar
                ],
              ),
            ),
          ),
          _buildSearchBar(context),
        ],
      ),
    );
  }

  Widget _buildShortcutSection(String title, List<Shortcut> shortcuts, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(spacing: 16, runSpacing: 24, alignment: WrapAlignment.start, children: shortcuts.map((shortcut) => _buildShortcutItem(shortcut, context)).toList()),
        ),
      ],
    );
  }

  Widget _buildShortcutItem(Shortcut shortcut, BuildContext context) {
    return SizedBox(
      width: 70,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _openUrl(context, shortcut.url),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, spreadRadius: 2)],
              ),
              child: ClipOval(
                child: Image.network(
                  shortcut.iconUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.language, color: Colors.grey[400], size: 32),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(shortcut.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Image.network('https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png', height: 24, errorBuilder: (context, error, stackTrace) => const Icon(Icons.search, color: Colors.blue)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Enter Website or URL', style: TextStyle(color: Colors.grey)),
          ),
          IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: () {}),
          IconButton(icon: const Icon(Icons.mic), onPressed: () {}),
        ],
      ),
    );
  }

  void _openUrl(BuildContext context, String url) {
    // Navigate to browser with URL
    Navigator.pushNamed(context, '/browser', arguments: url);
  }
}
