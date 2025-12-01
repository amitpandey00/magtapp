/// Abstract Failure class for error handling
abstract class Failure {
  final String message;
  const Failure(this.message);
  
  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred']) : super(message);
}

class FileFailure extends Failure {
  const FileFailure([String message = 'File operation failed']) : super(message);
}

class ParsingFailure extends Failure {
  const ParsingFailure([String message = 'Parsing failed']) : super(message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'Unknown error occurred']) : super(message);
}

