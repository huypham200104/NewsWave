import '../models/news_response_model.dart';

abstract class NewsRemoteDataSource {
  Future<NewsResponseModel> getTopHeadlines({required String apiKey});
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  // Sẽ dùng Dio để call API
  @override
  Future<NewsResponseModel> getTopHeadlines({required String apiKey}) async {
    // TODO: Implement API call với Dio
    throw UnimplementedError('API call chưa implement');
  }
}
