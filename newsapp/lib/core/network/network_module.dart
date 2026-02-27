import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio();
    
    // Cấu hình mặc định cho Dio
    dio.options.baseUrl = "https://newsapi.org/v2/"; // Base URL của NewsAPI
    dio.options.connectTimeout = const Duration(seconds: 10); // Timeout kết nối
    dio.options.receiveTimeout = const Duration(seconds: 10); // Timeout nhận dữ liệu
    
    // Thêm Log Interceptor để dễ debug (Optional)
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    return dio;
  }

  @lazySingleton
  InternetConnectionChecker get connectionChecker => InternetConnectionChecker.instance;
}