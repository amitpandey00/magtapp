import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../files/presentation/providers/file_storage_provider.dart';
import '../../../files/presentation/widgets/file_card.dart';
import '../../../files/presentation/widgets/document_viewer.dart';

class FileManagerScreen extends ConsumerStatefulWidget {
  const FileManagerScreen({super.key});

  @override
  ConsumerState<FileManagerScreen> createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends ConsumerState<FileManagerScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fileStorageProvider.notifier).loadDocuments();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileState = ref.watch(fileStorageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('File Manager'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.read(fileStorageProvider.notifier).loadDocuments(), tooltip: 'Refresh')],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search files...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(fileStorageProvider.notifier).searchDocuments('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                ref.read(fileStorageProvider.notifier).searchDocuments(value);
              },
            ),
          ),
          if (fileState.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (fileState.error != null)
            Expanded(child: Center(child: Text('Error: ${fileState.error}')))
          else if (fileState.documents.isEmpty)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_open, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No files yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                    SizedBox(height: 8),
                    Text('Download files from the browser to see them here', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: fileState.documents.length,
                itemBuilder: (context, index) {
                  final document = fileState.documents[index];
                  return FileCard(
                    document: document,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentViewer(document: document)));
                    },
                    onDelete: () => _deleteDocument(context, document.id),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _deleteDocument(BuildContext context, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File'),
        content: const Text('Are you sure you want to delete this file?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(fileStorageProvider.notifier).deleteDocument(id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File deleted')));
      }
    }
  }
}
