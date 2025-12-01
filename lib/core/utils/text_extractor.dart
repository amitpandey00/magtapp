/// Utility class for extracting text from various sources
class TextExtractor {
  /// Extract text from HTML content
  static String extractFromHtml(String html) {
    // Remove script and style tags
    String cleaned = html.replaceAll(RegExp(r'<script[^>]*>[\s\S]*?</script>'), '');
    cleaned = cleaned.replaceAll(RegExp(r'<style[^>]*>[\s\S]*?</style>'), '');
    
    // Remove HTML tags
    cleaned = cleaned.replaceAll(RegExp(r'<[^>]+>'), ' ');
    
    // Decode HTML entities
    cleaned = _decodeHtmlEntities(cleaned);
    
    // Clean up whitespace
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return cleaned;
  }

  /// Decode common HTML entities
  static String _decodeHtmlEntities(String text) {
    return text
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'");
  }

  /// Get word count from text
  static int getWordCount(String text) {
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  /// Truncate text to specified length
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  /// Calculate compression percentage
  static double calculateCompressionPercentage(int originalWords, int summaryWords) {
    if (originalWords == 0) return 0;
    return ((originalWords - summaryWords) / originalWords * 100);
  }
}

