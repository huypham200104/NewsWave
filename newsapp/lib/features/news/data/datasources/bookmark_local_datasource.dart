import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../models/article_model.dart';

abstract class BookmarkLocalDataSource {
  Future<void> saveBookmark(ArticleModel article);
  Future<void> removeBookmark(String url);
  Future<List<ArticleModel>> getBookmarks();
  Future<bool> checkBookmark(String url);
}

@LazySingleton(as: BookmarkLocalDataSource)
class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  static const String _bookmarksBox = 'bookmarks_cache';

  Future<Box> _openBox() async {
    if (!Hive.isBoxOpen(_bookmarksBox)) {
      return await Hive.openBox(_bookmarksBox);
    }
    return Hive.box(_bookmarksBox);
  }

  @override
  Future<void> saveBookmark(ArticleModel article) async {
    final box = await _openBox();
    // Sử dụng URL làm key để tránh trùng lặp
    await box.put(article.url, article.toJson());
  }

  @override
  Future<void> removeBookmark(String url) async {
    final box = await _openBox();
    await box.delete(url);
  }

  @override
  Future<List<ArticleModel>> getBookmarks() async {
    final box = await _openBox();
    final List<ArticleModel> bookmarks = [];
    
    for (var value in box.values) {
      try {
        final mapData = Map<String, dynamic>.from(value as Map);
        bookmarks.add(ArticleModel.fromJson(mapData));
      } catch (e) {
        debugPrint("Bookmark Error: $e");
        continue;
      }
    }
    return bookmarks;
  }

  @override
  Future<bool> checkBookmark(String url) async {
    final box = await _openBox();
    return box.containsKey(url);
  }
}
