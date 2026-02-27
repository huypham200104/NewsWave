import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../models/news_response_model.dart';

abstract class NewsRemoteDataSource {
  Future<NewsResponseModel> getTopHeadlines({required String apiKey});
}

@LazySingleton(as: NewsRemoteDataSource) // QUAN TRỌNG: Để Injectable nhận diện
class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio _dio;

  // Dio sẽ được tự động inject nhờ module ta sẽ tạo sau
  NewsRemoteDataSourceImpl(this._dio);

  @override
  Future<NewsResponseModel> getTopHeadlines({required String apiKey}) async {
    try {
      final response = await _dio.get(
        'top-headlines',
        queryParameters: {
          'country': 'us',
          'apiKey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        print('Parsing response...');
        final result = NewsResponseModel.fromJson(response.data);
        print('Parsed ${result.articles.length} articles');
        return result;
      } else {
        throw ServerException();
      }
    } catch (e) {
      print('Remote DataSource Error: $e');
      rethrow;
    }
  }
}