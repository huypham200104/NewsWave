import 'package:flutter_test/flutter_test.dart';
import 'package:news_wave/features/news/data/models/article_model.dart';
import 'package:news_wave/features/news/domain/entities/article_entity.dart';

void main() {
  // ─── Fixtures ────────────────────────────────────────────────────────
  const tSourceJson = {'id': 'cnn', 'name': 'CNN'};
  const tArticleJson = {
    'author': 'John Doe',
    'title': 'Flutter is awesome',
    'description': 'A great article',
    'url': 'https://example.com/article',
    'urlToImage': 'https://example.com/image.png',
    'publishedAt': '2024-01-01T10:00:00Z',
    'content': 'Full content here',
    'source': tSourceJson,
  };

  const tSourceModel = SourceModel(id: 'cnn', name: 'CNN');
  const tArticleModel = ArticleModel(
    author: 'John Doe',
    title: 'Flutter is awesome',
    description: 'A great article',
    url: 'https://example.com/article',
    urlToImage: 'https://example.com/image.png',
    publishedAt: '2024-01-01T10:00:00Z',
    content: 'Full content here',
    source: tSourceModel,
  );

  // ─── SourceModel ──────────────────────────────────────────────────────
  group('SourceModel', () {
    test('fromJson should correctly parse id and name', () {
      final result = SourceModel.fromJson(tSourceJson);
      expect(result.id, 'cnn');
      expect(result.name, 'CNN');
    });

    test('fromJson with null values should produce null fields', () {
      final result = SourceModel.fromJson({'id': null, 'name': null});
      expect(result.id, isNull);
      expect(result.name, isNull);
    });

    test('toJson should produce the correct map', () {
      final json = tSourceModel.toJson();
      expect(json['id'], 'cnn');
      expect(json['name'], 'CNN');
    });
  });

  // ─── ArticleModel – fromJson ──────────────────────────────────────────
  group('ArticleModel – fromJson', () {
    test('should correctly parse all fields from JSON', () {
      final result = ArticleModel.fromJson(tArticleJson);

      expect(result.author, 'John Doe');
      expect(result.title, 'Flutter is awesome');
      expect(result.description, 'A great article');
      expect(result.url, 'https://example.com/article');
      expect(result.urlToImage, 'https://example.com/image.png');
      expect(result.publishedAt, '2024-01-01T10:00:00Z');
      expect(result.content, 'Full content here');
      expect(result.source?.id, 'cnn');
      expect(result.source?.name, 'CNN');
    });

    test('should return null fields when JSON values are null', () {
      final result = ArticleModel.fromJson({
        'author': null,
        'title': null,
        'description': null,
        'url': null,
        'urlToImage': null,
        'publishedAt': null,
        'content': null,
        'source': null,
      });

      expect(result.author, isNull);
      expect(result.title, isNull);
      expect(result.source, isNull);
    });

    test('should handle missing keys gracefully (all default to null)', () {
      final result = ArticleModel.fromJson({});
      expect(result.title, isNull);
      expect(result.url, isNull);
    });
  });

  // ─── ArticleModel – toJson ────────────────────────────────────────────
  group('ArticleModel – toJson', () {
    test('should produce the correct JSON map with all fields present', () {
      final json = tArticleModel.toJson();

      expect(json['author'], 'John Doe');
      expect(json['title'], 'Flutter is awesome');
      expect(json['url'], 'https://example.com/article');
      expect(json['publishedAt'], '2024-01-01T10:00:00Z');
    });

    test('round-trip: fromJson → toJson should preserve all data', () {
      final model = ArticleModel.fromJson(tArticleJson);
      final json = model.toJson();

      expect(json['title'], tArticleJson['title']);
      expect(json['url'], tArticleJson['url']);
      expect(json['publishedAt'], tArticleJson['publishedAt']);
    });
  });

  // ─── ArticleModel – toEntity ──────────────────────────────────────────
  group('ArticleModel – toEntity', () {
    test('should map all fields correctly to ArticleEntity', () {
      final entity = tArticleModel.toEntity();

      expect(entity, isA<ArticleEntity>());
      expect(entity.author, 'John Doe');
      expect(entity.title, 'Flutter is awesome');
      expect(entity.description, 'A great article');
      expect(entity.url, 'https://example.com/article');
      expect(entity.urlToImage, 'https://example.com/image.png');
      expect(entity.content, 'Full content here');
      expect(entity.publishedAt, DateTime.parse('2024-01-01T10:00:00Z'));
    });

    test('should use default values when fields are null', () {
      const nullModel = ArticleModel();
      final entity = nullModel.toEntity();

      expect(entity.author, 'Unknown Author');
      expect(entity.title, 'No Title');
      expect(entity.description, 'No Description');
      expect(entity.url, '');
      expect(entity.urlToImage, '');
      expect(entity.content, '');
    });

    test('should use DateTime.now() when publishedAt is null or invalid', () {
      final before = DateTime.now();
      const nullModel = ArticleModel(publishedAt: 'invalid-date');
      final entity = nullModel.toEntity();
      final after = DateTime.now();

      // Should be within the test execution window
      expect(
        entity.publishedAt.isAfter(before.subtract(const Duration(seconds: 1))),
        isTrue,
      );
      expect(
        entity.publishedAt.isBefore(after.add(const Duration(seconds: 1))),
        isTrue,
      );
    });
  });
}
