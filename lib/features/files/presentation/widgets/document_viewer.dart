import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import '../../../../core/models/document.dart';

class DocumentViewer extends StatelessWidget {
  final Document document;

  const DocumentViewer({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(document.name, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareDocument(context),
            tooltip: 'Share',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getFileIcon(document.type), size: 100, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 24),
            Text(document.name, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(_formatFileSize(document.size), style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Type: ${document.type.toUpperCase()}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _openDocument(context),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open with External App'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'txt':
        return Icons.text_snippet;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  Future<void> _openDocument(BuildContext context) async {
    final result = await OpenFile.open(document.path);
    if (result.type != ResultType.done && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open file: ${result.message}')),
      );
    }
  }

  void _shareDocument(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality will be implemented')),
    );
  }
}

