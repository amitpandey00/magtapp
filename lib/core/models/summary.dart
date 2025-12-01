import 'package:hive/hive.dart';

part 'summary.g.dart';

@HiveType(typeId: 2)
class Summary {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String sourceId; // URL or document ID

  @HiveField(2)
  final String sourceType; // 'web' or 'document'

  @HiveField(3)
  final String originalText;

  @HiveField(4)
  final String summaryText;

  @HiveField(5)
  final int originalWordCount;

  @HiveField(6)
  final int summaryWordCount;

  @HiveField(7)
  final double compressionPercentage;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final String? title;

  Summary({
    required this.id,
    required this.sourceId,
    required this.sourceType,
    required this.originalText,
    required this.summaryText,
    required this.originalWordCount,
    required this.summaryWordCount,
    required this.compressionPercentage,
    required this.createdAt,
    this.title,
  });

  Summary copyWith({
    String? id,
    String? sourceId,
    String? sourceType,
    String? originalText,
    String? summaryText,
    int? originalWordCount,
    int? summaryWordCount,
    double? compressionPercentage,
    DateTime? createdAt,
    String? title,
  }) {
    return Summary(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      sourceType: sourceType ?? this.sourceType,
      originalText: originalText ?? this.originalText,
      summaryText: summaryText ?? this.summaryText,
      originalWordCount: originalWordCount ?? this.originalWordCount,
      summaryWordCount: summaryWordCount ?? this.summaryWordCount,
      compressionPercentage: compressionPercentage ?? this.compressionPercentage,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sourceId': sourceId,
      'sourceType': sourceType,
      'originalText': originalText,
      'summaryText': summaryText,
      'originalWordCount': originalWordCount,
      'summaryWordCount': summaryWordCount,
      'compressionPercentage': compressionPercentage,
      'createdAt': createdAt.toIso8601String(),
      'title': title,
    };
  }

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      id: json['id'],
      sourceId: json['sourceId'],
      sourceType: json['sourceType'],
      originalText: json['originalText'],
      summaryText: json['summaryText'],
      originalWordCount: json['originalWordCount'],
      summaryWordCount: json['summaryWordCount'],
      compressionPercentage: json['compressionPercentage'],
      createdAt: DateTime.parse(json['createdAt']),
      title: json['title'],
    );
  }
}

