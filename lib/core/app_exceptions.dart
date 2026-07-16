class AppException implements Exception {
  final String message;
  final String prefix;

  AppException([this.message = 'An unknown error occurred.', this.prefix = '']);

  @override
  String toString() {
    return "$prefix$message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message = 'Failed to fetch data']) : super(message, 'Error: ');
}

class BadRequestException extends AppException {
  BadRequestException([String message = 'Invalid Request']) : super(message, 'Invalid Request: ');
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String message = 'Unauthorised Request']) : super(message, 'Unauthorised: ');
}

class InvalidInputException extends AppException {
  InvalidInputException([String message = 'Invalid Input']) : super(message, 'Invalid Input: ');
}

class NetworkException extends AppException {
  NetworkException([String message = 'No internet connection']) : super(message, 'Network Error: ');
}

class FirebaseExceptionCustom extends AppException {
  FirebaseExceptionCustom([String message = 'A Firebase error occurred']) : super(message, 'Database Error: ');
}
