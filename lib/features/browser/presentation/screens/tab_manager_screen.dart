import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/browser_tab.dart';
import '../../../../core/models/shortcut.dart';
import '../providers/browser_state.dart';
import '../screens/browser_screen.dart';

/// Tab Manager Screen - Manage browser tabs with Normal/Incognito modes + Shortcuts
class TabManagerScreen extends ConsumerStatefulWidget {
  const TabManagerScreen({super.key});

  @override
  ConsumerState<TabManagerScreen> createState() => _TabManagerScreenState();
}

class _TabManagerScreenState extends ConsumerState<TabManagerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isNormalMode = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Changed to 4 tabs
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _isNormalMode = _tabController.index == 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _createNewTab(BuildContext context, bool isIncognito) {
    final newTab = BrowserTab(id: DateTime.now().millisecondsSinceEpoch.toString(), url: 'https://www.google.com', title: 'New Tab', createdAt: DateTime.now(), lastAccessedAt: DateTime.now(), isActive: true, isIncognito: isIncognito);
    ref.read(browserProvider.notifier).addTab(newTab);

    Navigator.push(context, MaterialPageRoute(builder: (context) => const BrowserScreen()));
  }

  void _closeTab(BuildContext context, String tabId) {
    ref.read(browserProvider.notifier).removeTab(tabId);
  }

  void _openTab(BuildContext context, String tabId) {
    ref.read(browserProvider.notifier).switchTab(tabId);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const BrowserScreen()));
  }

  void _closeAllTabs(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Close All Tabs'),
        content: Text('Are you sure you want to close all ${_isNormalMode ? 'normal' : 'incognito'} tabs?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final browserState = ref.read(browserProvider);
              final tabsToClose = browserState.tabs.where((tab) => tab.isIncognito != _isNormalMode).toList();
              for (final tab in tabsToClose) {
                ref.read(browserProvider.notifier).removeTab(tab.id);
              }
              Navigator.pop(context);
            },
            child: const Text('Close All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final browserState = ref.watch(browserProvider);
    final normalTabs = browserState.tabs.where((tab) => !tab.isIncognito).toList();
    final incognitoTabs = browserState.tabs.where((tab) => tab.isIncognito).toList();
    final currentTabs = _isNormalMode ? normalTabs : incognitoTabs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabs'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: [
            Tab(text: 'Normal (${normalTabs.length})'),
            Tab(text: 'Incognito (${incognitoTabs.length})'),
            const Tab(text: 'Social Media'),
            const Tab(text: 'Entertainment'),
          ],
        ),
        actions: [if (_tabController.index < 2 && currentTabs.isNotEmpty) IconButton(icon: const Icon(Icons.delete_sweep), onPressed: () => _closeAllTabs(context), tooltip: 'Close All Tabs')],
      ),
      body: TabBarView(controller: _tabController, physics: const NeverScrollableScrollPhysics(), children: [_buildTabList(context, normalTabs, false), _buildTabList(context, incognitoTabs, true), _buildShortcutsGrid(Shortcut.getShoppingShortcuts(), 'Social Media & Shopping'), _buildShortcutsGrid(Shortcut.getNewsShortcuts(), 'Entertainment & News')]),
      floatingActionButton: _tabController.index < 2 ? FloatingActionButton(onPressed: () => _createNewTab(context, !_isNormalMode), tooltip: 'New Tab', child: const Icon(Icons.add)) : null,
    );
  }

  Widget _buildTabList(BuildContext context, List<BrowserTab> tabs, bool isIncognito) {
    if (tabs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isIncognito ? Icons.privacy_tip : Icons.tab, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No ${isIncognito ? 'incognito' : 'normal'} tabs open', style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 8),
            ElevatedButton.icon(onPressed: () => _createNewTab(context, isIncognito), icon: const Icon(Icons.add), label: const Text('Create New Tab')),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 16, mainAxisSpacing: 16),
      itemCount: tabs.length,
      itemBuilder: (context, index) {
        final tab = tabs[index];
        return _buildTabCard(context, tab, isIncognito);
      },
    );
  }

  Widget _buildTabCard(BuildContext context, BrowserTab tab, bool isIncognito) {
    return GestureDetector(
      onTap: () => _openTab(context, tab.id),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isIncognito ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Center(child: Icon(isIncognito ? Icons.privacy_tip : Icons.public, size: 48, color: isIncognito ? Colors.white70 : Colors.grey[600])),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tab.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tab.url,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _closeTab(context, tab.id),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutsGrid(List<Shortcut> shortcuts, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.85, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemCount: shortcuts.length,
            itemBuilder: (context, index) {
              final shortcut = shortcuts[index];
              return _buildShortcutCard(shortcut);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShortcutCard(Shortcut shortcut) {
    return GestureDetector(
      onTap: () => _openUrl(shortcut.url),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, spreadRadius: 1)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                shortcut.iconUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.language, size: 32, color: Colors.blue[300]),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            shortcut.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _openUrl(String url) {
    final newTab = BrowserTab(id: DateTime.now().millisecondsSinceEpoch.toString(), url: url, title: 'Loading...', createdAt: DateTime.now(), lastAccessedAt: DateTime.now(), isActive: true);
    ref.read(browserProvider.notifier).addTab(newTab);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const BrowserScreen()));
  }
}
