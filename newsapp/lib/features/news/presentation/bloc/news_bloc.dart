import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart'; // <--- THÊM DÒNG NÀY
import '../../domain/entities/article_entity.dart';
import '../../domain/usecases/get_articles_usecase.dart';
import '../../domain/usecases/get_news_by_category_usecase.dart';
import '../../domain/usecases/search_news_usecase.dart';
import '../../domain/usecases/usecase.dart';
import '../../../../core/error/failure.dart';

// --- Events ---
abstract class NewsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetTopHeadlinesEvent extends NewsEvent {}

class GetNewsByCategoryEvent extends NewsEvent {
  final String category;
  GetNewsByCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class SearchNewsEvent extends NewsEvent {
  final String query;
  SearchNewsEvent(this.query);

  @override
  List<Object> get props => [query];
}

// --- States ---
abstract class NewsState extends Equatable {
  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}
class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<ArticleEntity> articles;
  NewsLoaded(this.articles);
  
  @override
  List<Object> get props => [articles]; // Nên thêm props để Equatable so sánh đúng
}

class NewsError extends NewsState {
  final String message;
  NewsError(this.message);

  @override
  List<Object> get props => [message];
}

// --- BLoC ---
@injectable // <--- QUAN TRỌNG: Đánh dấu class này để sinh code DI
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetArticlesUseCase getArticlesUseCase;
  final GetNewsByCategoryUseCase getNewsByCategoryUseCase;
  final SearchNewsUseCase searchNewsUseCase;

  // Injectable sẽ tự tìm GetArticlesUseCase đã đăng ký trước đó để điền vào đây
  NewsBloc(
    this.getArticlesUseCase,
    this.getNewsByCategoryUseCase,
    this.searchNewsUseCase,
  ) : super(NewsInitial()) {
    on<GetTopHeadlinesEvent>((event, emit) async {
      emit(NewsLoading());
      // Gọi UseCase
      final result = await getArticlesUseCase(NoParams());

      result.fold(
            (failure) => emit(NewsError(failure.message)),
            (articles) => emit(NewsLoaded(articles)),
      );
    });

    on<GetNewsByCategoryEvent>((event, emit) async {
      emit(NewsLoading());
      final result = await getNewsByCategoryUseCase(event.category);
      result.fold(
        (failure) => emit(NewsError(failure.message)),
        (articles) => emit(NewsLoaded(articles)),
      );
    });

    on<SearchNewsEvent>(_onSearchNews);
  }

  Future<void> _onSearchNews(
      SearchNewsEvent event, Emitter<NewsState> emit) async {
    if (event.query.isEmpty) return; // Preserve existing logic
    emit(NewsLoading());
    final result = await searchNewsUseCase(SearchParams(query: event.query));

    result.fold(
      (failure) => emit(NewsError(_mapFailureToMessage(failure))),
      (articles) => emit(NewsLoaded(articles)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server Error: Please try again later.';
    } else if (failure is CacheFailure) {
      return 'Cache Error: Data not available.';
    } else if (failure is NetworkFailure) {
      return 'Network Error: Please check your internet connection.';
    }
    return 'Unexpected Error: Please try again.';
  }
}