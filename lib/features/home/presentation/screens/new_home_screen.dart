import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/stock_ticker.dart';
import '../../../../core/models/news_article.dart';
import '../../../../core/models/app_feature.dart';
import '../../../browser/presentation/screens/browser_screen.dart';
import '../../../browser/presentation/providers/browser_state.dart';
import '../../../../core/models/browser_tab.dart';

import '../../data/services/news_service.dart';
import '../../data/services/stock_service.dart';
import '../../../language/presentation/providers/language_provider.dart';
import '../../../translator/data/services/gemini_translation_service.dart';
import '../../../../core/models/language.dart';

class NewHomeScreen extends ConsumerStatefulWidget {
  const NewHomeScreen({super.key});

  @override
  ConsumerState<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends ConsumerState<NewHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _stockScrollController;
  Timer? _scrollTimer;
  final List<String> _categories = ['Headlines', 'Sports', 'Business', 'Finance'];

  final NewsService _newsService = NewsService();
  final StockService _stockService = StockService();
  final GeminiTranslationService _translationService = GeminiTranslationService();

  List<StockTicker> _stocks = [];
  Map<String, List<NewsArticle>> _newsCache = {};
  Map<String, List<NewsArticle>> _translatedNewsCache = {};
  bool _isLoadingStocks = true;
  Language? _currentLanguage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadStocks();
    _loadNewsForAllCategories();
    _stockScrollController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_stockScrollController.hasClients && _stockScrollController.position.hasContentDimensions) {
        final maxScroll = _stockScrollController.position.maxScrollExtent;
        final currentScroll = _stockScrollController.offset;

        if (currentScroll >= maxScroll) {
          _stockScrollController.jumpTo(0);
        } else {
          _stockScrollController.animateTo(currentScroll + 1, duration: const Duration(milliseconds: 50), curve: Curves.linear);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _stockScrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to language changes
    ref.listen<LanguageState>(languageProvider, (previous, next) {
      if (previous?.selectedLanguage != next.selectedLanguage) {
        setState(() {
          _currentLanguage = next.selectedLanguage;
        });
        if (next.selectedLanguage != null) {
          _translateAllCategories(next.selectedLanguage!);
        }
      }
    });

    // Initialize language from provider if not set
    final selectedLanguage = ref.watch(languageProvider).selectedLanguage;
    if (_currentLanguage != selectedLanguage) {
      _currentLanguage = selectedLanguage;
      if (_currentLanguage != null) {
        _translateAllCategories(_currentLanguage!);
      }
    }

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
          IconButton(icon: const Icon(Icons.translate), onPressed: () => Navigator.pushNamed(context, '/language-selection')),
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildStockTicker(),
          _buildNewsTabs(),
          Expanded(
            child: TabBarView(controller: _tabController, physics: const NeverScrollableScrollPhysics(), children: _categories.map((category) => _buildNewsFeed(category)).toList()),
          ),
          _buildSearchBar(),
        ],
      ),
      floatingActionButton: Padding(padding: const EdgeInsets.only(bottom: 80), child: _buildFloatingActionButton(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildStockTicker() {
    if (_isLoadingStocks || _stocks.isEmpty) {
      return Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.grey[100],
        child: const Row(
          children: [
            Icon(Icons.show_chart, size: 20, color: Colors.grey),
            SizedBox(width: 8),
            Text('Loading stock data...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey[100],
      child: Row(
        children: [
          const Icon(Icons.show_chart, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: ListView.separated(
              controller: _stockScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _stocks.length * 5, // Repeat items for continuous scrolling
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('•', style: TextStyle(color: Colors.grey)),
              ),
              itemBuilder: (context, index) {
                final stock = _stocks[index % _stocks.length];
                return _buildStockItem(stock);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockItem(StockTicker stock) {
    final priceStr = stock.price.toStringAsFixed(2);
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13, color: Colors.black),
        children: [
          TextSpan(
            text: '${stock.symbol}: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: priceStr),
          if (stock.changePercent != 0.0) ...[
            const TextSpan(text: ' '),
            TextSpan(
              text: stock.isPositive ? '↑' : '↓',
              style: TextStyle(color: stock.isPositive ? Colors.green : Colors.red),
            ),
            TextSpan(
              text: ' ${stock.changePercent.abs().toStringAsFixed(2)}%',
              style: TextStyle(color: stock.isPositive ? Colors.green : Colors.red),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNewsTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.blue,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        tabs: _categories.map((category) => Tab(text: category)).toList(),
      ),
    );
  }

  Future<void> _loadStocks() async {
    try {
      final stocks = await _stockService.fetchIndianStocks();
      if (mounted) {
        setState(() {
          _stocks = stocks;
          _isLoadingStocks = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingStocks = false);
      }
    }
  }

  Future<void> _loadNewsForAllCategories() async {
    for (final category in _categories) {
      _loadNewsForCategory(category);
    }
  }

  Future<void> _loadNewsForCategory(String category) async {
    try {
      final news = await _newsService.fetchNewsByCategory(category);
      if (mounted) {
        setState(() {
          _newsCache[category] = news;
        });

        if (_currentLanguage != null) {
          _translateNewsForCategory(category, _currentLanguage!);
        }
      }
    } catch (e) {
      // Error handled by service with mock data
    }
  }

  Future<void> _translateAllCategories(Language targetLanguage) async {
    for (final category in _categories) {
      if (_newsCache.containsKey(category)) {
        _translateNewsForCategory(category, targetLanguage);
      }
    }
  }

  Future<void> _translateNewsForCategory(String category, Language targetLanguage) async {
    final news = _newsCache[category];
    if (news == null || news.isEmpty) return;

    final key = '${category}_${targetLanguage.code}';
    // If we already have translations for this language and category, don't re-translate
    // unless the news count differs (simple cache invalidation)
    if (_translatedNewsCache.containsKey(key) && _translatedNewsCache[key]!.length == news.length) {
      return;
    }

    final titles = news.map((a) => a.title).toList();
    // Assuming source is English for now
    final sourceLang = const Language(code: 'en', name: 'English', nativeName: 'English', category: 'international', colorHex: '#000000');

    try {
      // Show loading or just update when ready?
      // For now, we'll just update when ready. The UI will show English until then.

      final translations = await _translationService.translateBatch(titles, sourceLang, targetLanguage);

      final translatedArticles = <NewsArticle>[];
      for (int i = 0; i < news.length; i++) {
        if (i < translations.length) {
          final original = news[i];
          final translatedTitle = translations[i].translatedText;

          translatedArticles.add(NewsArticle(id: original.id, title: translatedTitle, description: original.description, imageUrl: original.imageUrl, source: original.source, sourceIcon: original.sourceIcon, publishedAt: original.publishedAt, url: original.url, category: original.category));
        }
      }

      if (mounted) {
        setState(() {
          _translatedNewsCache[key] = translatedArticles;
        });
      }
    } catch (e) {
      debugPrint('Translation failed for $category: $e');
    }
  }

  Widget _buildNewsFeed(String category) {
    List<NewsArticle>? news;

    if (_currentLanguage != null) {
      final key = '${category}_${_currentLanguage!.code}';
      news = _translatedNewsCache[key];
      // Fallback to English if translation not ready yet
      news ??= _newsCache[category];
    } else {
      news = _newsCache[category];
    }

    if (news == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (news.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.newspaper, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('No news available', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadNewsForCategory(category),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: news.length,
        itemBuilder: (context, index) {
          final article = news![index];
          return _buildNewsCard(article);
        },
      ),
    );
  }

  Widget _buildNewsCard(NewsArticle article) {
    return GestureDetector(
      onTap: () => _openUrl(article.url),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: article.imageUrl.isNotEmpty
                  ? Image.network(
                      article.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                      ),
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.article, size: 50, color: Colors.grey),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          article.source,
                          style: TextStyle(fontSize: 11, color: Colors.blue[700], fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Spacer(),
                      Text(article.timeAgo, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      const SizedBox(width: 8),
                      Icon(Icons.more_vert, size: 20, color: Colors.grey[600]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'home_fab', // Unique tag to avoid Hero conflict
      onPressed: () => _showFeaturesMenu(context),
      backgroundColor: Colors.blue,
      child: const Icon(Icons.star, color: Colors.white),
    );
  }

  void _showFeaturesMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.85, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemCount: AppFeature.getAllFeatures().length,
                itemBuilder: (context, index) {
                  final feature = AppFeature.getAllFeatures()[index];
                  return _buildFeatureItem(context, feature);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, AppFeature feature) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, feature.route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: feature.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(feature.icon, color: feature.color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            feature.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => _showSearchDialog(),
      child: Container(
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
      ),
    );
  }

  void _showSearchDialog() {
    final searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search or Enter URL'),
        content: TextField(
          controller: searchController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter website or search query', border: OutlineInputBorder()),
          onSubmitted: (value) {
            Navigator.pop(context);
            _performSearch(value);
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performSearch(searchController.text);
            },
            child: const Text('Go'),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    String url;
    if (query.startsWith('http://') || query.startsWith('https://')) {
      url = query;
    } else if (query.contains('.') && !query.contains(' ')) {
      url = 'https://$query';
    } else {
      url = 'https://www.google.com/search?q=${Uri.encodeComponent(query)}';
    }

    _openUrl(url);
  }

  void _openUrl(String url) {
    final newTab = BrowserTab(id: DateTime.now().millisecondsSinceEpoch.toString(), url: url, title: 'Loading...', createdAt: DateTime.now(), lastAccessedAt: DateTime.now(), isActive: true);
    ref.read(browserProvider.notifier).addTab(newTab);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const BrowserScreen()));
  }
}
