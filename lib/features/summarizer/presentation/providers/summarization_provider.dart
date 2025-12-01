import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/summary.dart';
import '../../data/services/mock_summarization_service.dart';

final summarizationServiceProvider = Provider<MockSummarizationService>((ref) {
  return MockSummarizationService();
});

class SummarizationState {
  final Summary? summary;
  final bool isLoading;
  final String? error;
  final List<Summary> savedSummaries;

  SummarizationState({this.summary, this.isLoading = false, this.error, this.savedSummaries = const []});

  SummarizationState copyWith({Summary? summary, bool? isLoading, String? error, List<Summary>? savedSummaries}) {
    return SummarizationState(summary: summary ?? this.summary, isLoading: isLoading ?? this.isLoading, error: error, savedSummaries: savedSummaries ?? this.savedSummaries);
  }
}

class SummarizationNotifier extends StateNotifier<SummarizationState> {
  final MockSummarizationService _service;

  SummarizationNotifier(this._service) : super(SummarizationState());

  Future<void> generateSummary(String text, {String? url}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final summary = await _service.generateSummary(text, url: url);
      await _service.saveSummary(summary);
      await loadSavedSummaries();
      state = state.copyWith(summary: summary, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
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

final summarizationProvider = StateNotifierProvider<SummarizationNotifier, SummarizationState>((ref) {
  final service = ref.watch(summarizationServiceProvider);
  return SummarizationNotifier(service);
});
