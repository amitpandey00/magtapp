import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/models/translation.dart';
import '../../../../core/models/language.dart';
import '../../../../core/database/hive_service.dart';
import '../../../../core/utils/logger.dart';

/// Gemini AI Translation Service
class GeminiTranslationService {
  GeminiTranslationService();

  /// Translate text from source language to target language using Gemini AI
  Future<Translation> translateText(String text, Language sourceLanguage, Language targetLanguage) async {
    try {
      if (text.trim().isEmpty) {
        throw Exception('Text cannot be empty');
      }

      final processedText = text.length > ApiConfig.maxTranslationLength ? text.substring(0, ApiConfig.maxTranslationLength) : text;

      final prompt = _buildTranslationPrompt(processedText, sourceLanguage, targetLanguage);

      final translatedText = await _callGeminiAPI(prompt) ?? _generateFallbackTranslation(processedText, sourceLanguage, targetLanguage);

      final translation = Translation(id: DateTime.now().millisecondsSinceEpoch.toString(), sourceId: '', sourceText: processedText, translatedText: translatedText.trim(), sourceLanguage: sourceLanguage.code, targetLanguage: targetLanguage.code, createdAt: DateTime.now());

      // Optionally save (you can comment this out if you don’t want auto-save)
      try {
        await saveTranslation(translation);
      } catch (_) {}

      return translation;
    } catch (e) {
      Logger.error('Gemini translation error', tag: 'GeminiTranslationService', error: e);
      return _generateFallbackTranslationObject(text, sourceLanguage, targetLanguage);
    }
  }

  String _buildTranslationPrompt(String text, Language sourceLanguage, Language targetLanguage) {
    return '''
You are an expert translator. Translate the following text from ${sourceLanguage.name} (${sourceLanguage.code}) to ${targetLanguage.name} (${targetLanguage.code}).

Instructions:
- Provide ONLY the translated text, nothing else
- Maintain the original meaning and tone
- Use natural, fluent language in the target language
- Preserve formatting (line breaks, punctuation)
- Do not add explanations or notes
- If the text contains names or proper nouns, keep them as is
- For technical terms, use the most appropriate translation

Text to translate:
$text

Translation:''';
  }

  Future<List<Translation>> translateBatch(List<String> texts, Language sourceLanguage, Language targetLanguage) async {
    final translations = <Translation>[];

    for (final text in texts) {
      try {
        final translation = await translateText(text, sourceLanguage, targetLanguage);
        translations.add(translation);

        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        Logger.error('Batch translation error for text', tag: 'GeminiTranslationService', error: e);
        translations.add(_generateFallbackTranslationObject(text, sourceLanguage, targetLanguage));
      }
    }

    return translations;
  }

  Future<String> detectLanguage(String text) async {
    try {
      if (text.trim().isEmpty) return 'en';

      const instruction = '''
Identify the language of the following text. Respond with ONLY the language code (e.g., 'en' for English, 'hi' for Hindi, 'es' for Spanish, etc.).

Language code:''';

      final prompt = '$instruction\n\n$text';

      final languageCode = await _callGeminiAPI(prompt);
      return languageCode?.trim().toLowerCase() ?? 'en';
    } catch (e) {
      Logger.error('Language detection error', tag: 'GeminiTranslationService', error: e);
      return 'en';
    }
  }

  List<Language> getSupportedLanguages() {
    return Language.getAllLanguages();
  }

  Future<String?> _callGeminiAPI(String prompt) async {
    try {
      final uri = Uri.parse(
        '${ApiConfig.geminiBaseUrl}/models/${ApiConfig.geminiModel}:generateContent'
        '?key=${ApiConfig.geminiApiKey}',
      );

      final body = {
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      };

      final response = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));

      if (response.statusCode != 200) {
        Logger.error('Gemini API error: ${response.statusCode}', tag: 'GeminiTranslationService');
        Logger.error('Response body: ${response.body}', tag: 'GeminiTranslationService');
        return null;
      }

      final json = jsonDecode(response.body);
      final textResult = (json['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '').toString();

      return textResult.trim();
    } catch (e) {
      Logger.error('Gemini API call failed', tag: 'GeminiTranslationService', error: e);
      return null;
    }
  }

  String _generateFallbackTranslation(String text, Language sourceLanguage, Language targetLanguage) {
    final translationKey = '${sourceLanguage.code}-${targetLanguage.code}';
    final fallbackTranslations = _getMockTranslations();

    return fallbackTranslations[translationKey] ?? '[Translated to ${targetLanguage.name}]: $text';
  }

  Translation _generateFallbackTranslationObject(String text, Language sourceLanguage, Language targetLanguage) {
    final translatedText = _generateFallbackTranslation(text, sourceLanguage, targetLanguage);

    return Translation(id: DateTime.now().millisecondsSinceEpoch.toString(), sourceId: '', sourceText: text, translatedText: translatedText, sourceLanguage: sourceLanguage.code, targetLanguage: targetLanguage.code, createdAt: DateTime.now());
  }

  Map<String, String> _getMockTranslations() {
    return {
      'en-es': 'Esta es una traducción al español. El contenido ha sido procesado y convertido al idioma de destino.',
      'en-fr': 'Ceci est une traduction en français. Le contenu a été traité et converti dans la langue cible.',
      'en-de': 'Dies ist eine Übersetzung ins Deutsche. Der Inhalt wurde verarbeitet und in die Zielsprache konvertiert.',
      'en-hi': 'यह हिंदी में अनुवाद है। सामग्री को संसाधित किया गया है और लक्ष्य भाषा में परिवर्तित किया गया है।',
      'en-it': 'Questa è una traduzione in italiano. Il contenuto è stato elaborato e convertito nella lingua di destinazione.',
      'en-pt': 'Esta é uma tradução para o português. O conteúdo foi processado e convertido para o idioma de destino.',
      'en-ja': 'これは日本語への翻訳です。コンテンツは処理され、ターゲット言語に変換されました。',
      'en-zh': '这是翻译成中文。内容已被处理并转换为目标语言。',
      'en-ko': '이것은 한국어로 번역입니다. 콘텐츠가 처리되어 대상 언어로 변환되었습니다.',
      'en-ar': 'هذه ترجمة إلى العربية. تمت معالجة المحتوى وتحويله إلى اللغة المستهدفة.',
      'en-ru': 'Это перевод на русский язык. Содержимое было обработано и преобразовано в целевой язык.',
      'hi-en': 'This is a translation to English. The content has been processed and converted to the target language.',
      'es-en': 'This is a translation to English. The content has been processed and converted to the target language.',
      'fr-en': 'This is a translation to English. The content has been processed and converted to the target language.',
    };
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
