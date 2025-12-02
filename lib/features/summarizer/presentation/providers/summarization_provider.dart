import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/summary.dart';
import '../../../../core/config/api_config.dart';
import '../../data/services/gemini_summarization_service.dart';
import '../../data/services/mock_summarization_service.dart';

// Service provider - uses Gemini if API key is set, otherwise uses mock
final summarizationServiceProvider = Provider((ref) {
  if (ApiConfig.geminiApiKey.isNotEmpty) {
    return GeminiSummarizationService();
  } else {
    return MockSummarizationService();
  }
});

class SummarizationState {
  final Summary? summary;
  final bool isLoading;
  final String? error;
  final List<Summary> savedSummaries;
  final String compressionLevel; // 'brief', 'moderate', 'detailed'

  SummarizationState({
    this.summary,
    this.isLoading = false,
    this.error,
    this.savedSummaries = const [],
    this.compressionLevel = 'moderate',
  });

  SummarizationState copyWith({
    Summary? summary,
    bool? isLoading,
    String? error,
    List<Summary>? savedSummaries,
    String? compressionLevel,
  }) {
    return SummarizationState(
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      savedSummaries: savedSummaries ?? this.savedSummaries,
      compressionLevel: compressionLevel ?? this.compressionLevel,
    );
  }
}

class SummarizationNotifier extends StateNotifier<SummarizationState> {
  final dynamic
  _service; // Can be either GeminiSummarizationService or MockSummarizationService

  SummarizationNotifier(this._service) : super(SummarizationState());

  /// Generate a summary with the current compression level
  Future<void> generateSummary(String text, {String? url}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      Summary summary;

      if (_service is GeminiSummarizationService) {
        summary = await _service.generateSummary(
          text,
          url: url,
          compressionLevel: state.compressionLevel,
        );
      } else {
        summary = await _service.generateSummary(text, url: url);
      }

      await _service.saveSummary(summary);
      await loadSavedSummaries();
      state = state.copyWith(summary: summary, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// Summarize a news article (optimized for news content)
  Future<void> summarizeNewsArticle(String articleText, String url) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      Summary summary;

      if (_service is GeminiSummarizationService) {
        summary = await _service.summarizeNewsArticle(articleText, url);
      } else {
        summary = await _service.generateSummary(articleText, url: url);
      }

      await _service.saveSummary(summary);
      await loadSavedSummaries();
      state = state.copyWith(summary: summary, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// Summarize a document (optimized for document content)
  Future<void> summarizeDocument(String documentText, String fileName) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      Summary summary;

      if (_service is GeminiSummarizationService) {
        summary = await _service.summarizeDocument(documentText, fileName);
      } else {
        summary = await _service.generateSummary(documentText, url: fileName);
      }

      await _service.saveSummary(summary);
      await loadSavedSummaries();
      state = state.copyWith(summary: summary, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// Set the compression level for summaries
  void setCompressionLevel(String level) {
    if (['brief', 'moderate', 'detailed'].contains(level)) {
      state = state.copyWith(compressionLevel: level);
    }
  }

  Future<void> loadSavedSummaries() async {
    try {
      final summaries = await _service.getSavedSummaries();
      state = state.copyWith(savedSummaries: summaries);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> saveSummary(Summary summary) async {
    try {
      await _service.saveSummary(summary);
      await loadSavedSummaries();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteSummary(String id) async {
    try {
      await _service.deleteSummary(id);
      await loadSavedSummaries();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearSummary() {
    state = state.copyWith(summary: null, error: null);
  }
}

final summarizationProvider =
    StateNotifierProvider<SummarizationNotifier, SummarizationState>((ref) {
      final service = ref.watch(summarizationServiceProvider);
      return SummarizationNotifier(service);
    });
