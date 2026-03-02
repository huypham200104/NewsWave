import 'package:equatable/equatable.dart';
import '../../../domain/entities/article_entity.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object> get props => [];
}

class LoadBookmarksEvent extends BookmarkEvent {}

class ToggleBookmarkEvent extends BookmarkEvent {
  final ArticleEntity article;

  const ToggleBookmarkEvent(this.article);

  @override
  List<Object> get props => [article];
}

class RemoveBookmarkEvent extends BookmarkEvent {
  final String url;

  const RemoveBookmarkEvent(this.url);

  @override
  List<Object> get props => [url];
}
