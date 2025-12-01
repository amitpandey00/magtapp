import '../../../../core/models/summary.dart';
import '../../../../core/database/hive_service.dart';

class MockSummarizationService {
  Future<Summary> generateSummary(String text, {String? url}) async {
    await Future.delayed(const Duration(seconds: 2));

    final originalWordCount = text.split(' ').length;
    final summaryText = _generateMockSummary(text, originalWordCount);
    final summaryWordCount = summaryText.split(' ').length;
    final compressionPercentage = ((1 - (summaryWordCount / originalWordCount)) * 100);

    return Summary(id: DateTime.now().millisecondsSinceEpoch.toString(), sourceId: url ?? '', sourceType: url != null ? 'web' : 'text', originalText: text, summaryText: summaryText, originalWordCount: originalWordCount, summaryWordCount: summaryWordCount, compressionPercentage: compressionPercentage, createdAt: DateTime.now());
  }

  String _generateMockSummary(String text, int wordCount) {
    if (wordCount < 50) {
      return 'This is a brief text that doesn\'t require extensive summarization. The content is concise and straightforward.';
    } else if (wordCount < 200) {
      return 'This document provides information on the given topic. The main content discusses key concepts and presents relevant details. The text covers essential points in a clear and organized manner.';
    } else if (wordCount < 500) {
      return 'This comprehensive document explores the subject matter in detail. It begins by introducing the main topic and provides context for understanding the key concepts. The content is structured to present information logically, covering various aspects of the subject. Important details are highlighted throughout the text, making it easier for readers to grasp the essential points. The document concludes by summarizing the main takeaways and their significance.';
    } else {
      return 'This extensive document provides an in-depth analysis of the subject matter. The content is organized into multiple sections, each addressing different aspects of the topic. The introduction sets the stage by providing background information and context. The main body explores various themes, concepts, and ideas in detail, supported by relevant examples and explanations. Key arguments are presented systematically, with supporting evidence and analysis. The document maintains a logical flow throughout, ensuring that complex ideas are broken down into understandable segments. Important findings and insights are highlighted at regular intervals. The conclusion synthesizes the main points and offers final thoughts on the implications and significance of the discussed topics.';
    }
  }

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
