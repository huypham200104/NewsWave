import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../models/news_response_model.dart';
import '../models/sources_response_model.dart';

abstract class NewsRemoteDataSource {
  Future<NewsResponseModel> getTopHeadlines({required String apiKey});
  Future<NewsResponseModel> getNewsByCategory({required String category, required String apiKey});
  Future<NewsResponseModel> searchNews({
    required String query,
    String? from,
    String? to,
    String? sortBy,
    required String apiKey,
  });
  Future<NewsResponseModel> getTrendingNews({required String apiKey});
  Future<SourcesResponseModel> getSources({required String apiKey});
  Future<NewsResponseModel> getNewsByCountry({required String country, required String apiKey});
  Future<NewsResponseModel> getNewsByCategoryAndCountry({
    required String category,
    required String country,
    required String apiKey,
  });
}

@LazySingleton(as: NewsRemoteDataSource) // QUAN TRỌNG: Để Injectable nhận diện
class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio _dio;

  // Dio sẽ được tự động inject nhờ module ta sẽ tạo sau
  NewsRemoteDataSourceImpl(this._dio);

  @override
  Future<NewsResponseModel> getTopHeadlines({required String apiKey}) async {
    return _getNewsFromUrl(
      'top-headlines',
      {
        'country': 'us',
        'apiKey': apiKey,
      },
    );
  }

  @override
  Future<NewsResponseModel> getNewsByCategory({
    required String category,
    required String apiKey,
  }) async {
    return _getNewsFromUrl(
      'top-headlines',
      {
        'country': 'us',
        'category': category,
        'apiKey': apiKey,
      },
    );
  }

  @override
  Future<NewsResponseModel> searchNews({
    required String query,
    String? from,
    String? to,
    String? sortBy,
    required String apiKey,
  }) async {
    final Map<String, dynamic> params = {
      'q': query,
      'apiKey': apiKey,
    };
    if (from != null) params['from'] = from;
    if (to != null) params['to'] = to;
    if (sortBy != null) params['sortBy'] = sortBy;

    return _getNewsFromUrl('everything', params);
  }

  @override
  Future<NewsResponseModel> getTrendingNews({required String apiKey}) async {
    return _getNewsFromUrl(
      'everything',
      {
        'q': 'news', // Endpoint /everything requires a query, or we use domains
        'sortBy': 'popularity',
        'apiKey': apiKey,
      },
    );
  }

  @override
  Future<SourcesResponseModel> getSources({required String apiKey}) async {
    try {
      final response = await _dio.get(
        'top-headlines/sources',
        queryParameters: {
          'apiKey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        return SourcesResponseModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      debugPrint('Remote DataSource Error (sources): $e');
      rethrow;
    }
  }

  @override
  Future<NewsResponseModel> getNewsByCountry({
    required String country,
    required String apiKey,
  }) async {
    return _getNewsFromUrl(
      'top-headlines',
      {
        'country': country,
        'apiKey': apiKey,
      },
    );
  }

  @override
  Future<NewsResponseModel> getNewsByCategoryAndCountry({
    required String category,
    required String country,
    required String apiKey,
  }) async {
    return _getNewsFromUrl(
      'top-headlines',
      {
        'country': country,
        'category': category,
        'apiKey': apiKey,
      },
    );
  }

  Future<NewsResponseModel> _getNewsFromUrl(
    String url,
    Map<String, dynamic> queryParameters,
  ) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return NewsResponseModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      debugPrint('Remote DataSource Error ($url): $e');
      rethrow;
    }
  }
}