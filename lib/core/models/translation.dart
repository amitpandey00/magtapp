import 'package:hive/hive.dart';

part 'translation.g.dart';

@HiveType(typeId: 3)
class Translation {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String sourceId; // URL or document ID

  @HiveField(2)
  final String sourceText;

  @HiveField(3)
  final String translatedText;

  @HiveField(4)
  final String sourceLanguage;

  @HiveField(5)
  final String targetLanguage;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final String? title;

  Translation({
    required this.id,
    required this.sourceId,
    required this.sourceText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.createdAt,
    this.title,
  });

  Translation copyWith({
    String? id,
    String? sourceId,
    String? sourceText,
    String? translatedText,
    String? sourceLanguage,
    String? targetLanguage,
    DateTime? createdAt,
    String? title,
  }) {
    return Translation(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      sourceText: sourceText ?? this.sourceText,
      translatedText: translatedText ?? this.translatedText,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sourceId': sourceId,
      'sourceText': sourceText,
      'translatedText': translatedText,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
      'createdAt': createdAt.toIso8601String(),
      'title': title,
    };
  }

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: json['id'],
      sourceId: json['sourceId'],
      sourceText: json['sourceText'],
      translatedText: json['translatedText'],
      sourceLanguage: json['sourceLanguage'],
      targetLanguage: json['targetLanguage'],
      createdAt: DateTime.parse(json['createdAt']),
      title: json['title'],
    );
  }
}

