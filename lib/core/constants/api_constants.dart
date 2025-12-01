/// API Constants for MagTapp
class ApiConstants {
  // Base URLs
  static const String summarizerBaseUrl = 'https://api.smmry.com';
  static const String translationBaseUrl = 'https://translate.googleapis.com';
  
  // API Keys (to be configured)
  static const String summarizerApiKey = 'YOUR_API_KEY_HERE';
  static const String translationApiKey = 'YOUR_API_KEY_HERE';
  
  // Endpoints
  static const String summarizeEndpoint = '/summarize';
  static const String translateEndpoint = '/translate';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Cache settings
  static const int maxCacheSize = 100; // Maximum cached items
  static const Duration cacheExpiration = Duration(days: 7);
}

