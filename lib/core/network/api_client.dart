import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';
import '../error/exceptions.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    // Add auth interceptor (for adding token to requests)
    _dio.interceptors.add(_AuthInterceptor());

    // Add error interceptor
    _dio.interceptors.add(_ErrorInterceptor());
  }

  // Get Dio instance
  Dio get dio => _dio;

  // Set authorization token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Clear authorization token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // Generic GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Generic POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Generic PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Generic DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Handle Dio errors and convert to app exceptions
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please check your internet connection.');
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? 'Server error occurred';
        
        if (statusCode == 401) {
          return ServerException('Unauthorized. Please login again.');
        } else if (statusCode == 403) {
          return ServerException('Forbidden. You don\'t have permission.');
        } else if (statusCode == 404) {
          return ServerException('Not found. Please check the URL.');
        } else if (statusCode! >= 500) {
          return ServerException('Server error. Please try again later.');
        } else {
          return ServerException(message);
        }
      
      case DioExceptionType.cancel:
        return NetworkException('Request cancelled.');
      
      case DioExceptionType.unknown:
      default:
        if (error.message?.contains('SocketException') ?? false) {
          return NetworkException('No internet connection. Please check your network.');
        }
        return NetworkException('An unexpected error occurred. Please try again.');
    }
  }
}

// Interceptor to handle authentication
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Token will be added via setAuthToken method
    // You can also get token from SharedPreferences here if needed
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 errors - clear token and redirect to login
    if (err.response?.statusCode == 401) {
      // Clear token and handle logout
      // You can add navigation logic here if needed
    }
    super.onError(err, handler);
  }
}

// Interceptor to handle errors globally
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Add any global error handling logic here
    super.onError(err, handler);
  }
}


