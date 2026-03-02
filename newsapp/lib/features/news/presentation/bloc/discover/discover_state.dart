import 'package:equatable/equatable.dart';
import '../../../domain/entities/article_entity.dart';
import '../../../domain/entities/news_source_entity.dart';

abstract class DiscoverState extends Equatable {
  const DiscoverState();

  @override
  List<Object?> get props => [];
}

class DiscoverInitial extends DiscoverState {}

class DiscoverLoading extends DiscoverState {}

class DiscoverLoaded extends DiscoverState {
  final List<ArticleEntity> trendingNews;
  final List<NewsSourceEntity> sources;
  final List<String> searchHistory;

  const DiscoverLoaded({
    required this.trendingNews,
    required this.sources,
    required this.searchHistory,
  });

  @override
  List<Object?> get props => [trendingNews, sources, searchHistory];
}

class DiscoverSearchLoaded extends DiscoverState {
  final List<ArticleEntity> searchResults;

  const DiscoverSearchLoaded({required this.searchResults});

  @override
  List<Object?> get props => [searchResults];
}

class DiscoverError extends DiscoverState {
  final String message;

  const DiscoverError(this.message);

  @override
  List<Object?> get props => [message];
}
