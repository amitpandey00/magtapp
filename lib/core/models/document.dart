import 'package:hive/hive.dart';

part 'document.g.dart';

@HiveType(typeId: 1)
class Document {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String path;

  @HiveField(3)
  final String type; // pdf, docx, pptx, xlsx

  @HiveField(4)
  final int size; // in bytes

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime lastModified;

  @HiveField(7)
  final bool isSummarized;

  @HiveField(8)
  final bool isCached;

  @HiveField(9)
  final String? thumbnailPath;

  Document({
    required this.id,
    required this.name,
    required this.path,
    required this.type,
    required this.size,
    required this.createdAt,
    required this.lastModified,
    this.isSummarized = false,
    this.isCached = false,
    this.thumbnailPath,
  });

  Document copyWith({
    String? id,
    String? name,
    String? path,
    String? type,
    int? size,
    DateTime? createdAt,
    DateTime? lastModified,
    bool? isSummarized,
    bool? isCached,
    String? thumbnailPath,
  }) {
    return Document(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      isSummarized: isSummarized ?? this.isSummarized,
      isCached: isCached ?? this.isCached,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'type': type,
      'size': size,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'isSummarized': isSummarized,
      'isCached': isCached,
      'thumbnailPath': thumbnailPath,
    };
  }

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      name: json['name'],
      path: json['path'],
      type: json['type'],
      size: json['size'],
      createdAt: DateTime.parse(json['createdAt']),
      lastModified: DateTime.parse(json['lastModified']),
      isSummarized: json['isSummarized'] ?? false,
      isCached: json['isCached'] ?? false,
      thumbnailPath: json['thumbnailPath'],
    );
  }
}

