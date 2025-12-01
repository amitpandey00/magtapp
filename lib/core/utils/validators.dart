/// Utility class for input validation
class Validators {
  /// Validate URL
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    
    // Add protocol if missing
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    
    final urlPattern = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    return urlPattern.hasMatch(url);
  }

  /// Format URL with protocol
  static String formatUrl(String url) {
    if (url.isEmpty) return url;
    
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    
    return url;
  }

  /// Check if string is a search query (not a URL)
  static bool isSearchQuery(String input) {
    return !isValidUrl(input) && !input.contains('.');
  }

  /// Convert search query to Google search URL
  static String searchQueryToUrl(String query) {
    final encodedQuery = Uri.encodeComponent(query);
    return 'https://www.google.com/search?q=$encodedQuery';
  }

  /// Validate file name
  static bool isValidFileName(String fileName) {
    if (fileName.isEmpty) return false;
    
    // Check for invalid characters
    final invalidChars = RegExp(r'[<>:"/\\|?*]');
    return !invalidChars.hasMatch(fileName);
  }

  /// Sanitize file name
  static String sanitizeFileName(String fileName) {
    // Replace invalid characters with underscore
    return fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  }
}

