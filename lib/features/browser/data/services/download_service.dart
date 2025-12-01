import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/models/document.dart';
import '../../../../core/utils/file_utils.dart';

class DownloadService {
  final Dio _dio;

  DownloadService(this._dio);

  /// Download file from URL
  Future<Document?> downloadFile(DownloadStartRequest downloadRequest, {Function(int, int)? onProgress}) async {
    try {
      final url = downloadRequest.url.toString();
      final suggestedFilename = downloadRequest.suggestedFilename ?? 'download';

      // Get downloads directory
      final directory = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${directory.path}/downloads');

      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      // Create file path
      final filePath = '${downloadsDir.path}/$suggestedFilename';
      final file = File(filePath);

      // Download file
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress?.call(received, total);
          }
        },
      );

      // Get file info
      final fileSize = await file.length();
      final fileType = FileUtils.getFileExtension(suggestedFilename);

      // Create document model
      final document = Document(id: DateTime.now().millisecondsSinceEpoch.toString(), name: suggestedFilename, path: filePath, type: fileType, size: fileSize, createdAt: DateTime.now(), lastModified: DateTime.now());

      final documentsBox = Hive.box<Document>('documents');
      await documentsBox.put(document.id, document);

      return document;
    } catch (e) {
      // Log error (in production, use proper logging)
      return null;
    }
  }

  /// Get download progress percentage
  double getProgress(int received, int total) {
    if (total == -1) return 0.0;
    return (received / total * 100);
  }

  /// Format download progress text
  String getProgressText(int received, int total) {
    final receivedMB = (received / 1024 / 1024).toStringAsFixed(2);
    final totalMB = (total / 1024 / 1024).toStringAsFixed(2);
    return '$receivedMB MB / $totalMB MB';
  }

  /// Cancel download (placeholder for future implementation)
  Future<void> cancelDownload(String downloadId) async {
    // TODO: Implement download cancellation
  }
}
