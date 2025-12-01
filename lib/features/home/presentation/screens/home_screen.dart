import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/shortcut.dart';
import '../../../browser/presentation/screens/browser_screen.dart';
import '../../../browser/presentation/providers/browser_state.dart';
import '../../../../core/models/browser_tab.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _openUrl(BuildContext context, WidgetRef ref, String url) {
    final newTab = BrowserTab(id: DateTime.now().millisecondsSinceEpoch.toString(), url: url, title: 'Loading...', createdAt: DateTime.now(), lastAccessedAt: DateTime.now(), isActive: true);

    ref.read(browserProvider.notifier).addTab(newTab);

    Navigator.push(context, MaterialPageRoute(builder: (context) => const BrowserScreen()));
  }

  void _performSearch(BuildContext context, WidgetRef ref, String query) {
    if (query.trim().isEmpty) return;

    String url;
    if (query.startsWith('http://') || query.startsWith('https://')) {
      url = query;
    } else if (query.contains('.') && !query.contains(' ')) {
      url = 'https://$query';
    } else {
      url = 'https://www.google.com/search?q=${Uri.encodeComponent(query)}';
    }

    _openUrl(context, ref, url);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shoppingShortcuts = Shortcut.getShoppingShortcuts();
    final newsShortcuts = Shortcut.getNewsShortcuts();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Shopping', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: shoppingShortcuts.length,
                      itemBuilder: (context, index) {
                        final shortcut = shoppingShortcuts[index];
                        return _buildShortcutItem(context, ref, shortcut);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('News', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: newsShortcuts.length,
                      itemBuilder: (context, index) {
                        final shortcut = newsShortcuts[index];
                        return _buildShortcutItem(context, ref, shortcut);
                      },
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          _buildSearchBar(context, ref),
        ],
      ),
    );
  }

  Widget _buildShortcutItem(BuildContext context, WidgetRef ref, Shortcut shortcut) {
    return GestureDetector(
      onTap: () => _openUrl(context, ref, shortcut.url),
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)],
              ),
              child: ClipOval(
                child: Image.network(
                  shortcut.iconUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.language, size: 30);
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(shortcut.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, WidgetRef ref) {
    final searchController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Image.network(
            'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.search, color: Colors.blue);
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(hintText: 'Search or type URL', border: InputBorder.none),
              onSubmitted: (value) => _performSearch(context, ref, value),
            ),
          ),
          IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: () {}),
          IconButton(icon: const Icon(Icons.mic), onPressed: () {}),
        ],
      ),
    );
  }
}
