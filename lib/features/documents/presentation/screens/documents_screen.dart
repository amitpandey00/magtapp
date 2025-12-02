import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import 'package:open_file/open_file.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  bool _visualMeaningEnabled = false;
  String _selectedCategory = 'all';
  bool _showPermissionDialog = true;
  List<PlatformFile> _documents = [];

  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'pdf',
      'name': 'PDF',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
    {
      'id': 'doc',
      'name': 'DOC',
      'icon': Icons.description,
      'color': Colors.blue,
    },
    {
      'id': 'ppt',
      'name': 'PPT',
      'icon': Icons.slideshow,
      'color': Colors.orange,
    },
    {
      'id': 'excel',
      'name': 'Excel',
      'icon': Icons.table_chart,
      'color': Colors.green,
    },
    {
      'id': 'folder',
      'name': 'Folder',
      'icon': Icons.folder,
      'color': Colors.yellow,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Documents',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildCategoryFilter(),
          Expanded(
            child: _showPermissionDialog
                ? _buildPermissionDialog()
                : _buildDocumentsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'CATEGORIES',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          Row(
            children: [
              const Text('Visual meaning on', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 8),
              Switch(
                value: _visualMeaningEnabled,
                onChanged: (value) {
                  setState(() => _visualMeaningEnabled = value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Visual Meaning ${value ? "Enabled" : "Disabled"}',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                activeColor: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category['id'];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category['id']),
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? category['color'].withOpacity(0.2)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: category['color'], width: 2)
                          : null,
                    ),
                    child: Icon(
                      category['icon'],
                      color: category['color'],
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['name'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPermissionDialog() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/file_access_illustration.png',
              height: 150,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.folder_open, size: 100, color: Colors.blue[300]),
            ),
            const SizedBox(height: 24),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'MagTapp '),
                  TextSpan(
                    text: 'needs File Access',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const TextSpan(text: ' in\norder to '),
                  TextSpan(
                    text: 'Show and Edit Document Files',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _requestFileAccess,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'ALLOW',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestFileAccess() async {
    setState(() => _showPermissionDialog = false);
    await _pickFiles();
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'],
        withData: true, // Important for Web to get bytes
      );

      if (result != null) {
        setState(() {
          _documents = result.files;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking files: $e')));
      }
    }
  }

  Future<void> _openFile(PlatformFile file) async {
    try {
      if (!kIsWeb && file.path != null) {
        await OpenFile.open(file.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Opening files directly on Web is not supported yet.',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error opening file: $e')));
      }
    }
  }

  String _getFileSize(PlatformFile file) {
    int bytes = file.size;
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _getFileName(PlatformFile file) {
    return file.name;
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  Widget _buildDocumentsList() {
    if (_documents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No documents selected',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickFiles,
              icon: const Icon(Icons.add),
              label: const Text('Pick Documents'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _documents.length,
      itemBuilder: (context, index) {
        final file = _documents[index];
        final fileName = _getFileName(file);
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(
              _getFileIcon(fileName),
              color: Colors.blue[700],
              size: 32,
            ),
            title: Text(fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(_getFileSize(file)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () => _openFile(file),
                  tooltip: 'Open file',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _documents.removeAt(index);
                    });
                  },
                  tooltip: 'Remove',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
