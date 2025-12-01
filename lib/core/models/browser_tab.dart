import 'package:hive/hive.dart';

part 'browser_tab.g.dart';

@HiveType(typeId: 0)
class BrowserTab {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime lastAccessedAt;

  @HiveField(5)
  final bool isActive;

  @HiveField(6)
  final String? favicon;

  @HiveField(7)
  final bool isSummarized;

  @HiveField(8)
  final bool isIncognito;

  @HiveField(9)
  final String? thumbnail;

  BrowserTab({required this.id, required this.url, required this.title, required this.createdAt, required this.lastAccessedAt, this.isActive = false, this.favicon, this.isSummarized = false, this.isIncognito = false, this.thumbnail});

  BrowserTab copyWith({String? id, String? url, String? title, DateTime? createdAt, DateTime? lastAccessedAt, bool? isActive, String? favicon, bool? isSummarized, bool? isIncognito, String? thumbnail}) {
    return BrowserTab(id: id ?? this.id, url: url ?? this.url, title: title ?? this.title, createdAt: createdAt ?? this.createdAt, lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt, isActive: isActive ?? this.isActive, favicon: favicon ?? this.favicon, isSummarized: isSummarized ?? this.isSummarized, isIncognito: isIncognito ?? this.isIncognito, thumbnail: thumbnail ?? this.thumbnail);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'title': title, 'createdAt': createdAt.toIso8601String(), 'lastAccessedAt': lastAccessedAt.toIso8601String(), 'isActive': isActive, 'favicon': favicon, 'isSummarized': isSummarized, 'isIncognito': isIncognito, 'thumbnail': thumbnail};
  }

  factory BrowserTab.fromJson(Map<String, dynamic> json) {
    return BrowserTab(id: json['id'], url: json['url'], title: json['title'], createdAt: DateTime.parse(json['createdAt']), lastAccessedAt: DateTime.parse(json['lastAccessedAt']), isActive: json['isActive'] ?? false, favicon: json['favicon'], isSummarized: json['isSummarized'] ?? false, isIncognito: json['isIncognito'] ?? false, thumbnail: json['thumbnail']);
  }
}
