import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../models/news_response_model.dart';
import '../models/sources_response_model.dart';

/// Remote data source for news API
/// API key is automatically added by Dio interceptor - Following SRP
abstract class NewsRemoteDataSource {
  Future<NewsResponseModel> getTopHeadlines();
  Future<NewsResponseModel> getNewsByCategory({required String category});
  Future<NewsResponseModel> searchNews({
    required String query,
    String? from,
    String? to,
    String? sortBy,
  });
  Future<NewsResponseModel> getTrendingNews();
  Future<SourcesResponseModel> getSources();
  Future<NewsResponseModel> getNewsByCountry({required String country});
  Future<NewsResponseModel> getNewsByCategoryAndCountry({
    required String category,
    required String country,
  });
}

@LazySingleton(as: NewsRemoteDataSource)
class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio _dio;

  NewsRemoteDataSourceImpl(this._dio);

  @override
  Future<NewsResponseModel> getTopHeadlines() async {
    return _getNewsFromUrl('top-headlines', {'country': 'us'});
  }

  @override
  Future<NewsResponseModel> getNewsByCategory({required String category}) async {
    return _getNewsFromUrl('top-headlines', {
      'country': 'us',
      'category': category,
    });
  }

  @override
  Future<NewsResponseModel> searchNews({
    required String query,
    String? from,
    String? to,
    String? sortBy,
  }) async {
    final Map<String, dynamic> params = {'q': query};
    if (from != null) params['from'] = from;
    if (to != null) params['to'] = to;
    if (sortBy != null) params['sortBy'] = sortBy;

    return _getNewsFromUrl('everything', params);
  }

  @override
  Future<NewsResponseModel> getTrendingNews() async {
    return _getNewsFromUrl('everything', {
      'q': 'news',
      'sortBy': 'popularity',
    });
  }

  @override
  Future<SourcesResponseModel> getSources() async {
    try {
      final response = await _dio.get('top-headlines/sources');

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
  Future<NewsResponseModel> getNewsByCountry({required String country}) async {
    return _getNewsFromUrl('top-headlines', {'country': country});
  }

  @override
  Future<NewsResponseModel> getNewsByCategoryAndCountry({
    required String category,
    required String country,
  }) async {
    return _getNewsFromUrl('top-headlines', {
      'country': country,
      'category': category,
    });
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