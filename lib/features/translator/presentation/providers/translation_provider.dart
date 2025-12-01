import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/translation.dart';
import '../../../../core/models/language.dart';
import '../../data/services/mock_translation_service.dart';

final translationServiceProvider = Provider<MockTranslationService>((ref) {
  return MockTranslationService();
});

class TranslationState {
  final Translation? translation;
  final bool isLoading;
  final String? error;
  final List<Translation> savedTranslations;
  final List<Language> supportedLanguages;
  final Language? sourceLanguage;
  final Language? targetLanguage;

  TranslationState({this.translation, this.isLoading = false, this.error, this.savedTranslations = const [], this.supportedLanguages = const [], this.sourceLanguage, this.targetLanguage});

  TranslationState copyWith({Translation? translation, bool? isLoading, String? error, List<Translation>? savedTranslations, List<Language>? supportedLanguages, Language? sourceLanguage, Language? targetLanguage}) {
    return TranslationState(translation: translation ?? this.translation, isLoading: isLoading ?? this.isLoading, error: error, savedTranslations: savedTranslations ?? this.savedTranslations, supportedLanguages: supportedLanguages ?? this.supportedLanguages, sourceLanguage: sourceLanguage ?? this.sourceLanguage, targetLanguage: targetLanguage ?? this.targetLanguage);
  }
}

class TranslationNotifier extends StateNotifier<TranslationState> {
  final MockTranslationService _service;

  TranslationNotifier(this._service) : super(TranslationState()) {
    _loadSupportedLanguages();
  }

  void _loadSupportedLanguages() {
    final languages = _service.getSupportedLanguages();
    state = state.copyWith(supportedLanguages: languages, sourceLanguage: languages.firstWhere((l) => l.code == 'en'), targetLanguage: languages.firstWhere((l) => l.code == 'es'));
  }

  Future<void> translateText(String text) async {
    if (state.sourceLanguage == null || state.targetLanguage == null) {
      state = state.copyWith(error: 'Please select source and target languages');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final translation = await _service.translateText(text, state.sourceLanguage!, state.targetLanguage!);
      await _service.saveTranslation(translation);
      await loadSavedTranslations();
      state = state.copyWith(translation: translation, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void setSourceLanguage(Language language) {
    state = state.copyWith(sourceLanguage: language);
  }

  void setTargetLanguage(Language language) {
    state = state.copyWith(targetLanguage: language);
  }

  void swapLanguages() {
    final temp = state.sourceLanguage;
    state = state.copyWith(sourceLanguage: state.targetLanguage, targetLanguage: temp);
  }

  Future<void> loadSavedTranslations() async {
    try {
      final translations = await _service.getSavedTranslations();
      state = state.copyWith(savedTranslations: translations);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> saveTranslation(Translation translation) async {
    try {
      await _service.saveTranslation(translation);
      await loadSavedTranslations();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteTranslation(String id) async {
    try {
      await _service.deleteTranslation(id);
      await loadSavedTranslations();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearTranslation() {
    state = state.copyWith(translation: null, error: null);
  }
}

final translationProvider = StateNotifierProvider<TranslationNotifier, TranslationState>((ref) {
  final service = ref.watch(translationServiceProvider);
  return TranslationNotifier(service);
});
