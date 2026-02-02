import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../models/article_model.dart';

abstract class NewsLocalDataSource {
  Future<void> cacheArticles(List<ArticleModel> articles);
  Future<List<ArticleModel>> getCachedArticles();
  Future<void> clearCache();
}

@LazySingleton(as: NewsLocalDataSource) // QUAN TRỌNG: Để Injectable nhận diện
class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  // Box name nên đặt cố định
  static const String _boxName = 'articles_cache';

  // Helper để mở box an toàn
  Future<Box> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  @override
  Future<void> cacheArticles(List<ArticleModel> articles) async {
    final box = await _openBox();
    await box.clear(); // Xóa cache cũ offline-first strategy
    
    // Lưu Map<String, dynamic> để tránh lỗi TypeAdapter nếu chưa register
    for (var i = 0; i < articles.length; i++) {
      await box.put(i, articles[i].toJson());
    }
  }

  @override
  Future<List<ArticleModel>> getCachedArticles() async {
    final box = await _openBox();
    final List<ArticleModel> articles = [];
    
    for (var value in box.values) {
      try {
        // Cast value về Map<String, dynamic> an toàn
        final mapData = Map<String, dynamic>.from(value as Map);
        articles.add(ArticleModel.fromJson(mapData));
      } catch (e) {
        print("Cache Error: $e"); // Log để debug
        continue;
      }
    }
    return articles;
  }

  @override
  Future<void> clearCache() async {
    final box = await _openBox();
    await box.clear();
  }
}