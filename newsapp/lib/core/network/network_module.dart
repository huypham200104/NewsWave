import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Network module for dependency injection
/// Provides configured Dio instance with API key interceptor
@module
abstract class NetworkModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio();
    
    // Base configuration
    dio.options.baseUrl = "https://newsapi.org/v2/";
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    
    // API Key Interceptor - Following Dependency Inversion Principle
    // Repository không cần biết về API key
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Automatically add API key to all requests
          options.queryParameters['apiKey'] = dotenv.env['NEWS_API_KEY'] ?? '';
          return handler.next(options);
        },
        onError: (error, handler) {
          // Có thể thêm error handling logic ở đây
          return handler.next(error);
        },
      ),
    );
    
    // Log Interceptor for debugging (optional)
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );

    return dio;
  }

  @lazySingleton
  InternetConnectionChecker get connectionChecker => InternetConnectionChecker.instance;
}