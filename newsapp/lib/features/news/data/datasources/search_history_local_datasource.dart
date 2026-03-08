import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class SearchHistoryLocalDataSource {
  Future<List<String>> getSearchHistory();
  Future<void> saveSearchHistory(String query);
  Future<void> clearSearchHistory();
}

@LazySingleton(as: SearchHistoryLocalDataSource)
class SearchHistoryLocalDataSourceImpl implements SearchHistoryLocalDataSource {
  static const String _searchHistoryBox = 'search_history_cache';
  static const String _historyKey = 'history_list';

  Future<Box> _openBox() async {
    if (!Hive.isBoxOpen(_searchHistoryBox)) {
      return await Hive.openBox(_searchHistoryBox);
    }
    return Hive.box(_searchHistoryBox);
  }

  @override
  Future<List<String>> getSearchHistory() async {
    final box = await _openBox();
    final List<dynamic>? history = box.get(_historyKey);
    if (history != null) {
      return history.cast<String>();
    }
    return [];
  }

  @override
  Future<void> saveSearchHistory(String query) async {
    final box = await _openBox();
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
    final box = await _openBox();
    await box.delete(_historyKey);
  }
}
