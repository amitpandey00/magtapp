/// News Article Model
class NewsArticle {
  final String id;
  final String title;
  final String? description;
  final String imageUrl;
  final String source;
  final String sourceIcon;
  final DateTime publishedAt;
  final String url;
  final String category;

  NewsArticle({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl,
    required this.source,
    required this.sourceIcon,
    required this.publishedAt,
    required this.url,
    required this.category,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'] ?? json['urlToImage'] ?? '',
      source: json['source'] ?? json['source']?['name'] ?? '',
      sourceIcon: json['sourceIcon'] ?? '',
      publishedAt: json['publishedAt'] != null ? DateTime.parse(json['publishedAt']) : DateTime.now(),
      url: json['url'] ?? '',
      category: json['category'] ?? 'general',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'source': source,
      'sourceIcon': sourceIcon,
      'publishedAt': publishedAt.toIso8601String(),
      'url': url,
      'category': category,
    };
  }
}

