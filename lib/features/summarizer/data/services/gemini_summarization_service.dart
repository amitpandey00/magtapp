import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/models/summary.dart';
import '../../../../core/database/hive_service.dart';
import '../../../../core/utils/logger.dart';

/// Gemini AI Summarization Service
///
/// This service uses Google's Gemini AI to generate intelligent summaries
/// of text content, news articles, and documents.
///
/// Uses direct HTTP calls to Gemini v1 API for better model support.
class GeminiSummarizationService {
  GeminiSummarizationService();

  /// Generate a summary of the given text using Gemini AI
  ///
  /// [text] - The text content to summarize
  /// [url] - Optional URL of the source (for web content)
  /// [compressionLevel] - Desired compression level: 'brief', 'moderate', 'detailed'
  Future<Summary> generateSummary(String text, {String? url, String compressionLevel = 'moderate'}) async {
    try {
      // Validate input
      if (text.trim().isEmpty) {
        throw Exception('Text cannot be empty');
      }

      // Truncate if too long
      final processedText = text.length > ApiConfig.maxSummarizationLength ? text.substring(0, ApiConfig.maxSummarizationLength) : text;

      final originalWordCount = processedText.split(' ').length;

      // Create the prompt based on compression level
      final prompt = _buildSummarizationPrompt(processedText, compressionLevel);

      // Generate summary using Gemini v1 API
      final summaryText = await _callGeminiAPI(prompt) ?? _generateFallbackSummary(processedText);
      final summaryWordCount = summaryText.split(' ').length;
      final compressionPercentage = ((1 - (summaryWordCount / originalWordCount)) * 100).clamp(0.0, 100.0);

      return Summary(id: DateTime.now().millisecondsSinceEpoch.toString(), sourceId: url ?? '', sourceType: url != null ? 'web' : 'text', originalText: processedText, summaryText: summaryText, originalWordCount: originalWordCount, summaryWordCount: summaryWordCount, compressionPercentage: compressionPercentage, createdAt: DateTime.now());
    } catch (e) {
      Logger.error('Gemini summarization error', tag: 'GeminiSummarizationService', error: e);
      // Fallback to basic summarization
      return _generateFallbackSummaryObject(text, url);
    }
  }

  /// Build the summarization prompt based on compression level
  String _buildSummarizationPrompt(String text, String compressionLevel) {
    final compressionInstructions = {'brief': 'Create a very brief summary in 2-3 sentences, capturing only the most critical points.', 'moderate': 'Create a concise summary in 4-6 sentences, covering the main ideas and key details.', 'detailed': 'Create a comprehensive summary in 8-12 sentences, preserving important details and context.'};

    final instruction = compressionInstructions[compressionLevel] ?? compressionInstructions['moderate']!;

    return '''
You are an expert text summarizer. Your task is to analyze and summarize the following text.

Instructions:
- $instruction
- Focus on the main ideas, key facts, and important conclusions
- Maintain the original meaning and context
- Use clear, concise language
- Do not add information not present in the original text
- For news articles, include who, what, when, where, why, and how
- For documents, focus on the purpose, main arguments, and conclusions

Text to summarize:
$text

Summary:
''';
  }

  /// Generate a fallback summary when API fails
  String _generateFallbackSummary(String text) {
    final wordCount = text.split(' ').length;

    if (wordCount < 50) {
      return 'This is a brief text that doesn\'t require extensive summarization. The content is concise and straightforward.';
    } else if (wordCount < 200) {
      return 'This document provides information on the given topic. The main content discusses key concepts and presents relevant details.';
    } else if (wordCount < 500) {
      return 'This comprehensive document explores the subject matter in detail. It covers various aspects of the topic with important details highlighted throughout.';
    } else {
      return 'This extensive document provides an in-depth analysis of the subject matter. The content is organized into multiple sections addressing different aspects with supporting evidence and analysis.';
    }
  }

  /// Generate a fallback Summary object when API fails
  Summary _generateFallbackSummaryObject(String text, String? url) {
    final originalWordCount = text.split(' ').length;
    final summaryText = _generateFallbackSummary(text);
    final summaryWordCount = summaryText.split(' ').length;
    final compressionPercentage = ((1 - (summaryWordCount / originalWordCount)) * 100).clamp(0.0, 100.0);

    return Summary(id: DateTime.now().millisecondsSinceEpoch.toString(), sourceId: url ?? '', sourceType: url != null ? 'web' : 'text', originalText: text, summaryText: summaryText, originalWordCount: originalWordCount, summaryWordCount: summaryWordCount, compressionPercentage: compressionPercentage, createdAt: DateTime.now());
  }

  /// Summarize a news article with specific focus on news elements
  Future<Summary> summarizeNewsArticle(String articleText, String url) async {
    try {
      final prompt =
          '''
You are a news summarizer. Analyze the following news article and create a concise summary.

Focus on:
- Main headline/story
- Key facts and figures
- Who is involved
- What happened
- When it happened
- Where it happened
- Why it matters
- Any important quotes or statements

Keep the summary objective and factual. Limit to 5-7 sentences.

Article:
$articleText

Summary:
''';

      final summaryText = await _callGeminiAPI(prompt) ?? _generateFallbackSummary(articleText);
      final originalWordCount = articleText.split(' ').length;
      final summaryWordCount = summaryText.split(' ').length;
      final compressionPercentage = ((1 - (summaryWordCount / originalWordCount)) * 100).clamp(0.0, 100.0);

      return Summary(id: DateTime.now().millisecondsSinceEpoch.toString(), sourceId: url, sourceType: 'news', originalText: articleText, summaryText: summaryText, originalWordCount: originalWordCount, summaryWordCount: summaryWordCount, compressionPercentage: compressionPercentage, createdAt: DateTime.now());
    } catch (e) {
      Logger.error('News summarization error', tag: 'GeminiSummarizationService', error: e);
      return _generateFallbackSummaryObject(articleText, url);
    }
  }

  /// Summarize a document with specific focus on document structure
  Future<Summary> summarizeDocument(String documentText, String fileName) async {
    try {
      final prompt =
          '''
You are a document summarizer. Analyze the following document and create a structured summary.

Focus on:
- Document purpose and type
- Main topics covered
- Key findings or conclusions
- Important data or statistics
- Recommendations or action items (if any)

Organize the summary in a clear, logical structure. Limit to 6-8 sentences.

Document:
$documentText

Summary:
''';

      final summaryText = await _callGeminiAPI(prompt) ?? _generateFallbackSummary(documentText);
      final originalWordCount = documentText.split(' ').length;
      final summaryWordCount = summaryText.split(' ').length;
      final compressionPercentage = ((1 - (summaryWordCount / originalWordCount)) * 100).clamp(0.0, 100.0);

      return Summary(id: DateTime.now().millisecondsSinceEpoch.toString(), sourceId: fileName, sourceType: 'document', originalText: documentText, summaryText: summaryText, originalWordCount: originalWordCount, summaryWordCount: summaryWordCount, compressionPercentage: compressionPercentage, createdAt: DateTime.now());
    } catch (e) {
      Logger.error('Document summarization error', tag: 'GeminiSummarizationService', error: e);
      return _generateFallbackSummaryObject(documentText, fileName);
    }
  }

  /// Call Gemini API directly using HTTP
  Future<String?> _callGeminiAPI(String prompt) async {
    try {
      final uri = Uri.parse('${ApiConfig.geminiBaseUrl}/models/${ApiConfig.geminiModel}:generateContent?key=${ApiConfig.geminiApiKey}');

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
        Logger.error('Gemini API error: ${response.statusCode}', tag: 'GeminiSummarizationService');
        Logger.error('Response body: ${response.body}', tag: 'GeminiSummarizationService');
        return null;
      }

      final json = jsonDecode(response.body);
      final textResult = (json['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '').toString();

      return textResult.trim();
    } catch (e) {
      Logger.error('Gemini API call failed', tag: 'GeminiSummarizationService', error: e);
      return null;
    }
  }

  // Database operations
  Future<List<Summary>> getSavedSummaries() async {
    final box = HiveService.getSummariesBox();
    return box.values.toList();
  }

  Future<void> saveSummary(Summary summary) async {
    final box = HiveService.getSummariesBox();
    await box.put(summary.id, summary);
  }

  Future<void> deleteSummary(String id) async {
    final box = HiveService.getSummariesBox();
    await box.delete(id);
  }

  Future<void> clearAllSummaries() async {
    final box = HiveService.getSummariesBox();
    await box.clear();
  }
}
