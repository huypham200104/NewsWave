import 'package:hive_flutter/hive_flutter.dart';
import '../models/article_model.dart';

// Offline data source for caching news articles locally using Hive database.
abstract class NewsLocalDataSource {
  Future<void> cacheArticles(List<ArticleModel> articles);
  Future<List<ArticleModel>> getCachedArticles();
  Future<void> clearCache();
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  static const String _boxName = 'articles_cache';
  
  Future<Box<Map>> get _box async => await Hive.openBox<Map>(_boxName);

  @override
  Future<void> cacheArticles(List<ArticleModel> articles) async {
    final box = await _box;
    await box.clear(); // Xóa cache cũ
    
    // Lưu từng article dưới dạng JSON Map
    for (var i = 0; i < articles.length; i++) {
      await box.put(i, articles[i].toJson());
    }
  }

  @override
  Future<List<ArticleModel>> getCachedArticles() async {
    final box = await _box;
    final List<ArticleModel> articles = [];
    
    for (var value in box.values) {
      try {
        articles.add(ArticleModel.fromJson(Map<String, dynamic>.from(value)));
      } catch (e) {
        // Bỏ qua các bản ghi lỗi
        continue;
      }
    }
    
    return articles;
  }

  @override
  Future<void> clearCache() async {
    final box = await _box;
    await box.clear();
  }
}