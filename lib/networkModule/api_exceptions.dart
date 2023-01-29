import 'package:flutter/cupertino.dart';

class APIExceptions implements Exception {
  final String message;
  final String prefix;
  APIExceptions({required this.message, required this.prefix});
  @override
  String toString() {
    return '$prefix $message';
  }
}

class FetchDataException extends APIExceptions {
  FetchDataException(String message)
      : super(message: message, prefix: 'Error During Communicate');
}

class BadRequestException extends APIExceptions {
  BadRequestException(String message)
      : super(message: message, prefix: 'Invalid request');
}

class UnauthorisedException extends APIExceptions {
  UnauthorisedException(String message)
      : super(message: message, prefix: 'Unauthorised ');
}

class InvalidInputException extends APIExceptions {
  InvalidInputException(String message)
      : super(message: message, prefix: 'Invalid Input ');
}

class AuthorisedException extends APIExceptions {
  AuthorisedException(String message)
      : super(message: message, prefix: 'Authorised failed');
}
