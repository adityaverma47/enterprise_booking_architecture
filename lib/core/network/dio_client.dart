import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../logging/app_logger.dart';
import '../utils/result.dart';

/// Centralized API client using Dio
/// Handles authentication, error handling, and request/response logging
class DioClient {
  final Dio _dio;
  final AppLogger _logger;
  final String baseUrl;

  DioClient({
    required this.baseUrl,
    required AppLogger logger,
    String? token,
  })  : _logger = logger,
        _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(milliseconds: AppConstants.connectionTimeout),
            receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _setupInterceptors(token);
  }

  void _setupInterceptors(String? token) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Attach token if available
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          _logger.debug(
            'Request: ${options.method} ${options.path}',
          );
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.debug(
            'Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger.error(
            'API Error: ${error.requestOptions.path}',
            error,
          );
          return handler.next(error);
        },
      ),
    );
  }

  void updateToken(String? token) {
    _dio.options.headers['Authorization'] = token != null ? 'Bearer $token' : null;
  }

  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      
      if (fromJson != null) {
        return Success(fromJson(response.data));
      }
      return Success(response.data as T);
    } on DioException catch (e) {
      return Failure(_handleError(e));
    } catch (e) {
      return Failure('Unexpected error: $e', e);
    }
  }

  Future<Result<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      
      if (fromJson != null) {
        return Success(fromJson(response.data));
      }
      return Success(response.data as T);
    } on DioException catch (e) {
      return Failure(_handleError(e));
    } catch (e) {
      return Failure('Unexpected error: $e', e);
    }
  }

  Future<Result<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      
      if (fromJson != null) {
        return Success(fromJson(response.data));
      }
      return Success(response.data as T);
    } on DioException catch (e) {
      return Failure(_handleError(e));
    } catch (e) {
      return Failure('Unexpected error: $e', e);
    }
  }

  Future<Result<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
      );
      
      if (fromJson != null) {
        return Success(fromJson(response.data));
      }
      return Success(response.data as T);
    } on DioException catch (e) {
      return Failure(_handleError(e));
    } catch (e) {
      return Failure('Unexpected error: $e', e);
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return 'Unauthorized. Please login again.';
        } else if (statusCode == 403) {
          return 'Access forbidden.';
        } else if (statusCode == 404) {
          return 'Resource not found.';
        } else if (statusCode == 500) {
          return 'Server error. Please try again later.';
        }
        return error.response?.data?['message'] ?? 'An error occurred';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.unknown:
        return 'Network error. Please check your connection.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}
