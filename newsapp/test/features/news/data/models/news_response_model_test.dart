import 'package:flutter_test/flutter_test.dart';
import 'package:news_wave/features/news/data/models/news_response_model.dart';
import 'package:news_wave/features/news/data/models/article_model.dart';

void main() {
  // ─── Fixtures ────────────────────────────────────────────────────────
  final tArticleJson = {
    'author': 'Jane Doe',
    'title': 'Breaking News',
    'description': 'Something happened',
    'url': 'https://example.com/news',
    'urlToImage': 'https://example.com/img.png',
    'publishedAt': '2024-06-01T00:00:00Z',
    'content': 'Content here',
    'source': {'id': 'bbc', 'name': 'BBC'},
  };

  final tResponseJson = {
    'status': 'ok',
    'totalResults': 1,
    'articles': [tArticleJson],
  };

  // ─── fromJson ─────────────────────────────────────────────────────────
  group('NewsResponseModel – fromJson', () {
    test('should correctly parse status and totalResults', () {
      final result = NewsResponseModel.fromJson(tResponseJson);

      expect(result.status, 'ok');
      expect(result.totalResults, 1);
    });

    test('should correctly parse articles list', () {
      final result = NewsResponseModel.fromJson(tResponseJson);

      expect(result.articles, isA<List<ArticleModel>>());
      expect(result.articles.length, 1);
      expect(result.articles.first.title, 'Breaking News');
    });

    test('should return empty list when articles key is null', () {
      final result = NewsResponseModel.fromJson({
        'status': 'ok',
        'totalResults': 0,
        'articles': null,
      });

      expect(result.articles, isEmpty);
    });

    test('should return empty list when articles key is missing', () {
      final result = NewsResponseModel.fromJson({
        'status': 'error',
        'totalResults': 0,
      });

      expect(result.articles, isEmpty);
      expect(result.totalResults, 0);
    });

    test('should use empty string for missing status', () {
      final result = NewsResponseModel.fromJson({'totalResults': 5});
      expect(result.status, '');
    });

    test('should parse multiple articles correctly', () {
      final result = NewsResponseModel.fromJson({
        'status': 'ok',
        'totalResults': 2,
        'articles': [tArticleJson, tArticleJson],
      });

      expect(result.articles.length, 2);
    });
  });

  // ─── toJson ───────────────────────────────────────────────────────────
  group('NewsResponseModel – toJson', () {
    test('should produce a map with status, totalResults, and articles', () {
      final model = NewsResponseModel.fromJson(tResponseJson);
      final json = model.toJson();

      expect(json['status'], 'ok');
      expect(json['totalResults'], 1);
      expect(json['articles'], isA<List>());
    });

    test('round-trip: fromJson → toJson should preserve data integrity', () {
      final model = NewsResponseModel.fromJson(tResponseJson);
      final json = model.toJson();
      final model2 = NewsResponseModel.fromJson(json);

      expect(model2.status, model.status);
      expect(model2.totalResults, model.totalResults);
      expect(model2.articles.length, model.articles.length);
      expect(model2.articles.first.title, model.articles.first.title);
    });
  });
}
