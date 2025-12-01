import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/document.dart';
import '../../data/services/file_storage_service.dart';

final fileStorageServiceProvider = Provider<FileStorageService>((ref) {
  return FileStorageService();
});

class FileStorageState {
  final List<Document> documents;
  final bool isLoading;
  final String? error;
  final String? searchQuery;

  FileStorageState({
    this.documents = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery,
  });

  FileStorageState copyWith({
    List<Document>? documents,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return FileStorageState(
      documents: documents ?? this.documents,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class FileStorageNotifier extends StateNotifier<FileStorageState> {
  final FileStorageService _storageService;

  FileStorageNotifier(this._storageService) : super(FileStorageState());

  Future<void> loadDocuments() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final documents = await _storageService.getAllDocuments();
      state = state.copyWith(documents: documents, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> searchDocuments(String query) async {
    state = state.copyWith(isLoading: true, searchQuery: query);
    try {
      final documents = query.isEmpty ? await _storageService.getAllDocuments() : await _storageService.searchDocuments(query);
      state = state.copyWith(documents: documents, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> deleteDocument(String id) async {
    try {
      await _storageService.deleteDocument(id);
      await loadDocuments();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> addDocument(Document document) async {
    try {
      await _storageService.saveDocument(document);
      await loadDocuments();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<int> getTotalStorageUsed() async {
    return await _storageService.getTotalStorageUsed();
  }
}

final fileStorageProvider = StateNotifierProvider<FileStorageNotifier, FileStorageState>((ref) {
  final storageService = ref.watch(fileStorageServiceProvider);
  return FileStorageNotifier(storageService);
});

