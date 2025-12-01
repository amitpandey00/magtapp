import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/browser_tab.dart';

/// Browser State
class BrowserState {
  final List<BrowserTab> tabs;
  final String? activeTabId;
  final bool isLoading;
  final double progress;
  final String? error;

  BrowserState({
    this.tabs = const [],
    this.activeTabId,
    this.isLoading = false,
    this.progress = 0.0,
    this.error,
  });

  BrowserState copyWith({
    List<BrowserTab>? tabs,
    String? activeTabId,
    bool? isLoading,
    double? progress,
    String? error,
  }) {
    return BrowserState(
      tabs: tabs ?? this.tabs,
      activeTabId: activeTabId ?? this.activeTabId,
      isLoading: isLoading ?? this.isLoading,
      progress: progress ?? this.progress,
      error: error ?? this.error,
    );
  }

  BrowserTab? get activeTab {
    if (activeTabId == null) return null;
    try {
      return tabs.firstWhere((tab) => tab.id == activeTabId);
    } catch (e) {
      return null;
    }
  }

  int get tabCount => tabs.length;
}

/// Browser State Notifier
class BrowserNotifier extends StateNotifier<BrowserState> {
  BrowserNotifier() : super(BrowserState());

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setProgress(double progress) {
    state = state.copyWith(progress: progress);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void addTab(BrowserTab tab) {
    final updatedTabs = [...state.tabs, tab];
    state = state.copyWith(
      tabs: updatedTabs,
      activeTabId: tab.id,
    );
  }

  void removeTab(String tabId) {
    final updatedTabs = state.tabs.where((tab) => tab.id != tabId).toList();
    String? newActiveTabId = state.activeTabId;
    
    if (state.activeTabId == tabId && updatedTabs.isNotEmpty) {
      newActiveTabId = updatedTabs.last.id;
    } else if (updatedTabs.isEmpty) {
      newActiveTabId = null;
    }

    state = state.copyWith(
      tabs: updatedTabs,
      activeTabId: newActiveTabId,
    );
  }

  void switchTab(String tabId) {
    state = state.copyWith(activeTabId: tabId);
  }

  void updateTab(String tabId, BrowserTab updatedTab) {
    final updatedTabs = state.tabs.map((tab) {
      return tab.id == tabId ? updatedTab : tab;
    }).toList();

    state = state.copyWith(tabs: updatedTabs);
  }

  void updateTabUrl(String tabId, String url, String title) {
    final tab = state.tabs.firstWhere((t) => t.id == tabId);
    final updatedTab = tab.copyWith(
      url: url,
      title: title,
      lastAccessedAt: DateTime.now(),
    );
    updateTab(tabId, updatedTab);
  }

  void clearAllTabs() {
    state = BrowserState();
  }
}

/// Browser Provider
final browserProvider = StateNotifierProvider<BrowserNotifier, BrowserState>((ref) {
  return BrowserNotifier();
});

