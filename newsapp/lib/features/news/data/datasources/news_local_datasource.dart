import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../models/article_model.dart';

abstract class NewsLocalDataSource {
  Future<void> cacheArticles(List<ArticleModel> articles);
  Future<List<ArticleModel>> getCachedArticles();
  Future<void> clearCache();

  // Search History
  Future<List<String>> getSearchHistory();
  Future<void> saveSearchHistory(String query);
  Future<void> clearSearchHistory();

  // Bookmarks
  Future<void> saveBookmark(ArticleModel article);
  Future<void> removeBookmark(String url);
  Future<List<ArticleModel>> getBookmarks();
  Future<bool> checkBookmark(String url);
}

@LazySingleton(as: NewsLocalDataSource) // QUAN TRỌNG: Để Injectable nhận diện
class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  // Box name nên đặt cố định
  static const String _boxName = 'articles_cache';
  static const String _searchHistoryBox = 'search_history_cache';
  static const String _bookmarksBox = 'bookmarks_cache';
  static const String _historyKey = 'history_list';

  // Helper để mở box an toàn
  Future<Box> _openBox(String name) async {
    if (!Hive.isBoxOpen(name)) {
      return await Hive.openBox(name);
    }
    return Hive.box(name);
  }

  @override
  Future<void> cacheArticles(List<ArticleModel> articles) async {
    final box = await _openBox(_boxName);
    await box.clear(); // Xóa cache cũ offline-first strategy
    
    // Lưu Map<String, dynamic> để tránh lỗi TypeAdapter nếu chưa register
    for (var i = 0; i < articles.length; i++) {
      await box.put(i, articles[i].toJson());
    }
  }

  @override
  Future<List<ArticleModel>> getCachedArticles() async {
    final box = await _openBox(_boxName);
    final List<ArticleModel> articles = [];
    
    for (var value in box.values) {
      try {
        final mapData = Map<String, dynamic>.from(value as Map);
        articles.add(ArticleModel.fromJson(mapData));
      } catch (e) {
        debugPrint("Cache Error: $e");
        continue;
      }
    }
    return articles;
  }

  @override
  Future<void> clearCache() async {
    final box = await _openBox(_boxName);
    await box.clear();
  }

  @override
  Future<List<String>> getSearchHistory() async {
    final box = await _openBox(_searchHistoryBox);
    final List<dynamic>? history = box.get(_historyKey);
    if (history != null) {
      return history.cast<String>();
    }
    return [];
  }

  @override
  Future<void> saveSearchHistory(String query) async {
    final box = await _openBox(_searchHistoryBox);
    List<String> history = await getSearchHistory();
    // Xóa query cũ nếu đã tồn tại để đưa lên đầu
    history.removeWhere((q) => q.toLowerCase() == query.toLowerCase());
    history.insert(0, query); // Đưa query mới nhất lên đầu
    
    // Giới hạn max 10 lịch sử
    if (history.length > 10) {
      history = history.sublist(0, 10);
    }
    
    await box.put(_historyKey, history);
  }

  @override
  Future<void> clearSearchHistory() async {
    final box = await _openBox(_searchHistoryBox);
    await box.delete(_historyKey);
  }

  @override
  Future<void> saveBookmark(ArticleModel article) async {
    final box = await _openBox(_bookmarksBox);
    await box.put(article.url, article.toJson());
  }

  @override
  Future<void> removeBookmark(String url) async {
    final box = await _openBox(_bookmarksBox);
    await box.delete(url);
  }

  @override
  Future<List<ArticleModel>> getBookmarks() async {
    final box = await _openBox(_bookmarksBox);
    final List<ArticleModel> articles = [];
    
    for (var value in box.values) {
      try {
        final mapData = Map<String, dynamic>.from(value as Map);
        articles.add(ArticleModel.fromJson(mapData));
      } catch (e) {
        debugPrint("Bookmark Error: $e");
        continue;
      }
    }
    return articles.reversed.toList();
  }

  @override
  Future<bool> checkBookmark(String url) async {
    final box = await _openBox(_bookmarksBox);
    return box.containsKey(url);
  }
}
