import 'package:dio/dio.dart';
import 'failure.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) return _fromDio(error);
    return Failure.unknown('Unexpected error: $error');
  }

  static Failure _fromDio(DioException e) => switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError => const Failure.network(
      'No internet connection.',
    ),

    DioExceptionType.badResponse => Failure.server(
      'Server error: ${e.response?.statusCode}',
    ),

    _ => const Failure.unknown('An unexpected error occurred.'),
  };
}
