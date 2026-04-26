import 'package:dio/dio.dart';

sealed class NetworkFailure {
  const NetworkFailure();

  static NetworkFailure fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return const UnauthorizedFailure();
        }
        return ServerFailure(statusCode ?? 500);
      case DioExceptionType.cancel:
      case DioExceptionType.connectionError:
        return const ConnectionFailure();
      case DioExceptionType.badCertificate:
        return const ServerFailure(403);
      case DioExceptionType.unknown:
        return ParseFailure(e.error ?? 'Unknown error');
    }
  }
}

class ServerFailure extends NetworkFailure {
  final int statusCode;
  const ServerFailure(this.statusCode);
}

class ConnectionFailure extends NetworkFailure {
  const ConnectionFailure();
}

class TimeoutFailure extends NetworkFailure {
  const TimeoutFailure();
}

class ParseFailure extends NetworkFailure {
  final Object error;
  const ParseFailure(this.error);
}

class UnauthorizedFailure extends NetworkFailure {
  const UnauthorizedFailure();
}
