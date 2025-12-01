/// Custom Exceptions for MagTapp

class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error occurred']);
  
  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error occurred']);
  
  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error occurred']);
  
  @override
  String toString() => 'NetworkException: $message';
}

class FileException implements Exception {
  final String message;
  FileException([this.message = 'File operation error occurred']);
  
  @override
  String toString() => 'FileException: $message';
}

class ParsingException implements Exception {
  final String message;
  ParsingException([this.message = 'Parsing error occurred']);
  
  @override
  String toString() => 'ParsingException: $message';
}

