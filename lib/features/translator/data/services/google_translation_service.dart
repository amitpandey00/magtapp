import 'package:dio/dio.dart';

/// Google Translation API Service
/// Documentation: https://cloud.google.com/translate/docs/reference/rest
class GoogleTranslationService {
  final Dio _dio = Dio();
  
  // Get your API key from: https://console.cloud.google.com/apis/credentials
  static const String _apiKey = 'YOUR_GOOGLE_API_KEY_HERE';
  static const String _baseUrl = 'https://translation.googleapis.com/language/translate/v2';

  /// Translate text from source language to target language
  Future<String> translateText({
    required String text,
    required String targetLanguage,
    String? sourceLanguage,
  }) async {
    try {
      if (_apiKey == 'YOUR_GOOGLE_API_KEY_HERE') {
        // Return mock translation if API key not set
        return _getMockTranslation(text, targetLanguage);
      }

      final response = await _dio.post(
        _baseUrl,
        queryParameters: {
          'key': _apiKey,
        },
        data: {
          'q': text,
          'target': targetLanguage,
          if (sourceLanguage != null) 'source': sourceLanguage,
          'format': 'text',
        },
      );

      if (response.statusCode == 200) {
        final translatedText = response.data['data']['translations'][0]['translatedText'];
        return translatedText;
      }

      return _getMockTranslation(text, targetLanguage);
    } catch (e) {
      print('Translation error: $e');
      return _getMockTranslation(text, targetLanguage);
    }
  }

  /// Detect language of text
  Future<String> detectLanguage(String text) async {
    try {
      if (_apiKey == 'YOUR_GOOGLE_API_KEY_HERE') {
        return 'en'; // Default to English
      }

      final response = await _dio.post(
        '$_baseUrl/detect',
        queryParameters: {
          'key': _apiKey,
        },
        data: {
          'q': text,
        },
      );

      if (response.statusCode == 200) {
        final detectedLanguage = response.data['data']['detections'][0][0]['language'];
        return detectedLanguage;
      }

      return 'en';
    } catch (e) {
      print('Language detection error: $e');
      return 'en';
    }
  }

  /// Get list of supported languages
  Future<List<Map<String, String>>> getSupportedLanguages() async {
    try {
      if (_apiKey == 'YOUR_GOOGLE_API_KEY_HERE') {
        return _getMockLanguages();
      }

      final response = await _dio.get(
        '$_baseUrl/languages',
        queryParameters: {
          'key': _apiKey,
          'target': 'en', // Get language names in English
        },
      );

      if (response.statusCode == 200) {
        final languages = (response.data['data']['languages'] as List)
            .map((lang) => {
                  'code': lang['language'] as String,
                  'name': lang['name'] as String,
                })
            .toList();
        return languages;
      }

      return _getMockLanguages();
    } catch (e) {
      print('Error fetching languages: $e');
      return _getMockLanguages();
    }
  }

  /// Mock translation for testing
  String _getMockTranslation(String text, String targetLanguage) {
    return '[Translated to $targetLanguage]: $text';
  }

  /// Mock supported languages
  List<Map<String, String>> _getMockLanguages() {
    return [
      {'code': 'en', 'name': 'English'},
      {'code': 'hi', 'name': 'Hindi'},
      {'code': 'es', 'name': 'Spanish'},
      {'code': 'fr', 'name': 'French'},
      {'code': 'de', 'name': 'German'},
      {'code': 'zh', 'name': 'Chinese'},
      {'code': 'ja', 'name': 'Japanese'},
      {'code': 'ko', 'name': 'Korean'},
      {'code': 'ar', 'name': 'Arabic'},
      {'code': 'pt', 'name': 'Portuguese'},
      {'code': 'ru', 'name': 'Russian'},
      {'code': 'it', 'name': 'Italian'},
      {'code': 'bn', 'name': 'Bengali'},
      {'code': 'ta', 'name': 'Tamil'},
      {'code': 'te', 'name': 'Telugu'},
      {'code': 'mr', 'name': 'Marathi'},
      {'code': 'gu', 'name': 'Gujarati'},
      {'code': 'kn', 'name': 'Kannada'},
      {'code': 'ml', 'name': 'Malayalam'},
      {'code': 'pa', 'name': 'Punjabi'},
    ];
  }
}

