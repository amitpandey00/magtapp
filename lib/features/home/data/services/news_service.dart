import 'package:dio/dio.dart';
import '../../../../core/models/news_article.dart';
import '../../../../core/utils/logger.dart';

/// Service for fetching news articles
class NewsService {
  final Dio _dio = Dio();

  // NewsAPI.org API key (Free tier: 100 requests/day)
  // Get your free API key from: https://newsapi.org/
  static const String _apiKey = 'YOUR_API_KEY_HERE'; // Replace with actual API key
  static const String _baseUrl = 'https://newsapi.org/v2';

  /// Fetch news articles by category
  Future<List<NewsArticle>> fetchNewsByCategory(String category) async {
    try {
      // If API key is not set, return mock data
      if (_apiKey == 'YOUR_API_KEY_HERE') {
        return _getMockNews(category);
      }

      final response = await _dio.get(
        '$_baseUrl/top-headlines',
        queryParameters: {
          'country': 'in', // India
          'category': _mapCategory(category),
          'apiKey': _apiKey,
          'pageSize': 20,
        },
      );

      if (response.statusCode == 200) {
        final articles = (response.data['articles'] as List).map((article) => NewsArticle.fromJson(article)).toList();
        return articles;
      }

      return _getMockNews(category);
    } catch (e) {
      Logger.error('Error fetching news', tag: 'NewsService', error: e);
      return _getMockNews(category);
    }
  }

  /// Map UI category to NewsAPI category
  String _mapCategory(String category) {
    switch (category.toLowerCase()) {
      case 'headlines':
        return 'general';
      case 'sports':
        return 'sports';
      case 'business':
        return 'business';
      case 'finance':
        return 'business';
      default:
        return 'general';
    }
  }

  /// Get mock news data for testing
  List<NewsArticle> _getMockNews(String category) {
    final now = DateTime.now();
    final categoryLower = category.toLowerCase();
    final categoryHash = categoryLower.hashCode.abs();

    // Generate category-specific titles
    final titles = _getCategorySpecificTitles(category);

    // Real news website URLs based on category
    final urls = _getCategorySpecificUrls(categoryLower);

    return List.generate(5, (index) {
      return NewsArticle(
        id: '$categoryLower-${index + 1}',
        title: titles[index],
        description: 'This is a sample ${category.toLowerCase()} news article. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        imageUrl: 'https://picsum.photos/400/250?random=$categoryHash${index + 1}',
        source: ['TOI', 'NDTV', 'India Today', 'The Hindu', 'BBC'][index],
        sourceIcon: ['https://logo.clearbit.com/timesofindia.com', 'https://logo.clearbit.com/ndtv.com', 'https://logo.clearbit.com/indiatoday.in', 'https://logo.clearbit.com/thehindu.com', 'https://logo.clearbit.com/bbc.com'][index],
        publishedAt: now.subtract(Duration(hours: index + 1)),
        url: urls[index],
        category: categoryLower,
      );
    });
  }

  /// Generate category-specific titles
  List<String> _getCategorySpecificTitles(String category) {
    switch (category.toLowerCase()) {
      case 'headlines':
        return ['Breaking: Prime Minister Announces New Economic Reforms', 'India Successfully Launches Chandrayaan-4 Mission', 'Major Infrastructure Project Completed Ahead of Schedule', 'Supreme Court Delivers Historic Verdict on Privacy Rights', 'Record-Breaking Monsoon Brings Relief to Farmers'];
      case 'sports':
        return ['India Wins Cricket World Cup Final in Thrilling Match', 'Olympic Gold: Indian Athlete Sets New World Record', 'IPL 2024: Mumbai Indians Clinch Championship Title', 'Neeraj Chopra Wins Diamond League with Record Throw', 'Indian Football Team Qualifies for FIFA World Cup'];
      case 'business':
        return ['Sensex Hits All-Time High, Crosses 90,000 Mark', 'Major Tech Company Announces ₹10,000 Crore Investment in India', 'Startup Unicorn: Indian Fintech Valued at \$5 Billion', 'RBI Announces New Monetary Policy, Keeps Rates Unchanged', 'E-Commerce Giant Reports 40% Growth in Quarterly Revenue'];
      case 'finance':
        return ['Budget 2024: Tax Reforms and Infrastructure Spending Announced', 'Rupee Strengthens Against Dollar, Reaches 82.50', 'Gold Prices Surge to Record High Amid Global Uncertainty', 'Stock Market Analysis: Top Performing Sectors This Quarter', 'Mutual Funds See Record Inflows of ₹50,000 Crore'];
      default:
        return ['Breaking: Major Development in ${category.toUpperCase()}', 'Latest Update: Important News in $category', 'Exclusive: New Developments in $category Today', 'Analysis: What This Means for $category', 'Report: Comprehensive Coverage of $category Events'];
    }
  }

  /// Generate category-specific URLs from real news websites
  List<String> _getCategorySpecificUrls(String category) {
    switch (category.toLowerCase()) {
      case 'headlines':
        return ['https://timesofindia.indiatimes.com/', 'https://www.ndtv.com/', 'https://www.indiatoday.in/', 'https://www.thehindu.com/', 'https://www.bbc.com/news/world/asia/india'];
      case 'sports':
        return ['https://timesofindia.indiatimes.com/sports', 'https://sports.ndtv.com/', 'https://www.indiatoday.in/sports', 'https://www.thehindu.com/sport/', 'https://www.bbc.com/sport'];
      case 'business':
        return ['https://timesofindia.indiatimes.com/business', 'https://www.ndtv.com/business', 'https://www.indiatoday.in/business', 'https://www.thehindu.com/business/', 'https://www.bbc.com/news/business'];
      case 'finance':
        return ['https://economictimes.indiatimes.com/', 'https://www.ndtv.com/business', 'https://www.indiatoday.in/business', 'https://www.thehindu.com/business/', 'https://www.bbc.com/news/business'];
      default:
        return ['https://timesofindia.indiatimes.com/', 'https://www.ndtv.com/', 'https://www.indiatoday.in/', 'https://www.thehindu.com/', 'https://www.bbc.com/news'];
    }
  }
}
