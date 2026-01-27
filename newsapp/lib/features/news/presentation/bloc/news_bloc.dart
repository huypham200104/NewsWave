import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/article_entity.dart';
import '../../domain/usecases/get_articles_usecase.dart';

// --- Events ---
abstract class NewsEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class GetTopHeadlinesEvent extends NewsEvent {}

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
}
class NewsError extends NewsState {
  final String message;
  NewsError(this.message);
}

// --- BLoC ---
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetArticlesUseCase getArticlesUseCase;

  NewsBloc(this.getArticlesUseCase) : super(NewsInitial()) {
    on<GetTopHeadlinesEvent>((event, emit) async {
      emit(NewsLoading());
      final result = await getArticlesUseCase.call();

      result.fold(
            (failure) => emit(NewsError(failure.message)),
            (articles) => emit(NewsLoaded(articles)),
      );
    });
  }
}