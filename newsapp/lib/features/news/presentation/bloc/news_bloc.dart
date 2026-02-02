import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart'; // <--- THÊM DÒNG NÀY
import '../../domain/entities/article_entity.dart';
import '../../domain/usecases/get_articles_usecase.dart';
import '../../domain/usecases/usecase.dart';

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

  // Injectable sẽ tự tìm GetArticlesUseCase đã đăng ký trước đó để điền vào đây
  NewsBloc(this.getArticlesUseCase) : super(NewsInitial()) {
    on<GetTopHeadlinesEvent>((event, emit) async {
      emit(NewsLoading());
      // Gọi UseCase
      final result = await getArticlesUseCase(NoParams());

      result.fold(
            (failure) => emit(NewsError(failure.message)),
            (articles) => emit(NewsLoaded(articles)),
      );
    });
  }
}