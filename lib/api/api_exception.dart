class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  const NetworkException([String message = 'No internet connection'])
      : super(message);
}

class TimeoutException extends ApiException {
  const TimeoutException([String message = 'Request timed out'])
      : super(message);
}

class BadRequestException extends ApiException {
  const BadRequestException([String message = 'Bad request'])
      : super(message);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException([String message = 'Unauthorized'])
      : super(message);
}

class NotFoundException extends ApiException {
  const NotFoundException([String message = 'Resource not found'])
      : super(message);
}

class ServerException extends ApiException {
  const ServerException([String message = 'Internal server error'])
      : super(message);
}

class UnknownException extends ApiException {
  const UnknownException([String message = 'Something went wrong'])
      : super(message);
}