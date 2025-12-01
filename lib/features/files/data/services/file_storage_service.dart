import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/models/document.dart';

class FileStorageService {
  static const String _documentsBoxName = 'documents';

  Box<Document> get _documentsBox => Hive.box<Document>(_documentsBoxName);

  Future<List<Document>> getAllDocuments() async {
    return _documentsBox.values.toList();
  }

  Future<void> saveDocument(Document document) async {
    await _documentsBox.put(document.id, document);
  }

  Future<Document?> getDocument(String id) async {
    return _documentsBox.get(id);
  }

  Future<void> deleteDocument(String id) async {
    final document = _documentsBox.get(id);
    if (document != null) {
      final file = File(document.path);
      if (await file.exists()) {
        await file.delete();
      }
      await _documentsBox.delete(id);
    }
  }

  Future<void> updateDocument(Document document) async {
    await _documentsBox.put(document.id, document);
  }

  Future<List<Document>> getDocumentsByType(String type) async {
    return _documentsBox.values.where((doc) => doc.type == type).toList();
  }

  Future<List<Document>> searchDocuments(String query) async {
    final lowerQuery = query.toLowerCase();
    return _documentsBox.values.where((doc) => doc.name.toLowerCase().contains(lowerQuery)).toList();
  }

  Future<int> getTotalStorageUsed() async {
    int total = 0;
    for (var doc in _documentsBox.values) {
      total += doc.size;
    }
    return total;
  }

  Future<String> getDownloadsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('${directory.path}/downloads');
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }
    return downloadsDir.path;
  }

  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  Future<void> clearAllDocuments() async {
    for (var doc in _documentsBox.values) {
      final file = File(doc.path);
      if (await file.exists()) {
        await file.delete();
      }
    }
    await _documentsBox.clear();
  }
}

