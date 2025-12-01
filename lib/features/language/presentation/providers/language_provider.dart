import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../../core/models/language.dart';
import '../../../../core/database/hive_service.dart';

class LanguageState {
  final Language? selectedLanguage;
  final bool isLoading;

  LanguageState({
    this.selectedLanguage,
    this.isLoading = false,
  });

  LanguageState copyWith({
    Language? selectedLanguage,
    bool? isLoading,
  }) {
    return LanguageState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LanguageNotifier extends StateNotifier<LanguageState> {
  LanguageNotifier() : super(LanguageState()) {
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final box = Hive.box(HiveService.settingsBox);
    final languageCode = box.get('selectedLanguageCode');
    
    if (languageCode != null) {
      final language = Language.getLanguageByCode(languageCode);
      if (language != null) {
        state = state.copyWith(selectedLanguage: language);
      }
    }
  }

  Future<void> selectLanguage(Language language) async {
    state = state.copyWith(selectedLanguage: language);
    
    final box = Hive.box(HiveService.settingsBox);
    await box.put('selectedLanguageCode', language.code);
  }

  Future<void> clearLanguage() async {
    state = state.copyWith(selectedLanguage: null);
    
    final box = Hive.box(HiveService.settingsBox);
    await box.delete('selectedLanguageCode');
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, LanguageState>((ref) {
  return LanguageNotifier();
});

