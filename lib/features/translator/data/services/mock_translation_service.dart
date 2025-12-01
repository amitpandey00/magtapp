import '../../../../core/models/translation.dart';
import '../../../../core/models/language.dart';
import '../../../../core/database/hive_service.dart';

class MockTranslationService {
  final Map<String, String> _mockTranslations = {'en-es': 'Esta es una traducción simulada al español. El contenido ha sido procesado y convertido al idioma de destino.', 'en-fr': 'Ceci est une traduction simulée en français. Le contenu a été traité et converti dans la langue cible.', 'en-de': 'Dies ist eine simulierte Übersetzung ins Deutsche. Der Inhalt wurde verarbeitet und in die Zielsprache konvertiert.', 'en-it': 'Questa è una traduzione simulata in italiano. Il contenuto è stato elaborato e convertito nella lingua di destinazione.', 'en-pt': 'Esta é uma tradução simulada para o português. O conteúdo foi processado e convertido para o idioma de destino.', 'en-ja': 'これは日本語へのシミュレートされた翻訳です。コンテンツは処理され、ターゲット言語に変換されました。', 'en-zh': '这是模拟翻译成中文。内容已被处理并转换为目标语言。', 'en-ko': '이것은 한국어로 시뮬레이션된 번역입니다. 콘텐츠가 처리되어 대상 언어로 변환되었습니다.', 'en-ar': 'هذه ترجمة محاكاة إلى العربية. تمت معالجة المحتوى وتحويله إلى اللغة المستهدفة.', 'en-ru': 'Это имитация перевода на русский язык. Содержимое было обработано и преобразовано в целевой язык.'};

  Future<Translation> translateText(String text, Language sourceLanguage, Language targetLanguage) async {
    await Future.delayed(const Duration(seconds: 2));

    final translationKey = '${sourceLanguage.code}-${targetLanguage.code}';
    final translatedText = _mockTranslations[translationKey] ?? 'Translation to ${targetLanguage.name}: $text';

    return Translation(id: DateTime.now().millisecondsSinceEpoch.toString(), sourceId: '', sourceText: text, translatedText: translatedText, sourceLanguage: sourceLanguage.code, targetLanguage: targetLanguage.code, createdAt: DateTime.now());
  }

  List<Language> getSupportedLanguages() {
    return Language.getAllLanguages();
  }

  Future<List<Translation>> getSavedTranslations() async {
    final box = HiveService.getTranslationsBox();
    return box.values.toList();
  }

  Future<void> saveTranslation(Translation translation) async {
    final box = HiveService.getTranslationsBox();
    await box.put(translation.id, translation);
  }

  Future<void> deleteTranslation(String id) async {
    final box = HiveService.getTranslationsBox();
    await box.delete(id);
  }

  Future<void> clearAllTranslations() async {
    final box = HiveService.getTranslationsBox();
    await box.clear();
  }
}
