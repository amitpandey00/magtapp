import 'dart:io';
import 'package:path/path.dart' as path;

/// Utility class for file operations
class FileUtils {
  /// Get file extension
  static String getFileExtension(String filePath) {
    return path.extension(filePath).toLowerCase();
  }

  /// Get file name without extension
  static String getFileNameWithoutExtension(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }

  /// Get file name with extension
  static String getFileName(String filePath) {
    return path.basename(filePath);
  }

  /// Check if file is a document
  static bool isDocument(String filePath) {
    final ext = getFileExtension(filePath);
    return ['.pdf', '.doc', '.docx', '.txt', '.ppt', '.pptx', '.xls', '.xlsx']
        .contains(ext);
  }

  /// Check if file is a PDF
  static bool isPdf(String filePath) {
    return getFileExtension(filePath) == '.pdf';
  }

  /// Check if file is a Word document
  static bool isWordDocument(String filePath) {
    final ext = getFileExtension(filePath);
    return ['.doc', '.docx'].contains(ext);
  }

  /// Check if file is an Excel document
  static bool isExcelDocument(String filePath) {
    final ext = getFileExtension(filePath);
    return ['.xls', '.xlsx'].contains(ext);
  }

  /// Check if file is a PowerPoint document
  static bool isPowerPointDocument(String filePath) {
    final ext = getFileExtension(filePath);
    return ['.ppt', '.pptx'].contains(ext);
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Get file size
  static Future<int> getFileSize(String filePath) async {
    final file = File(filePath);
    return await file.length();
  }

  /// Delete file
  static Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Check if file exists
  static Future<bool> fileExists(String filePath) async {
    final file = File(filePath);
    return await file.exists();
  }
}

