import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/get_sources_usecase.dart';
import '../../../domain/usecases/get_trending_news_usecase.dart';
import '../../../domain/usecases/search_news_usecase.dart';
import '../../../domain/usecases/get_search_history_usecase.dart';
import '../../../domain/usecases/save_search_history_usecase.dart';
import '../../../domain/usecases/clear_search_history_usecase.dart';
import '../../../domain/usecases/usecase.dart';
import '../../../../../core/error/failure.dart';
import 'discover_event.dart';
import 'discover_state.dart';

@injectable
class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final GetTrendingNewsUseCase getTrendingNewsUseCase;
  final GetSourcesUseCase getSourcesUseCase;
  final SearchNewsUseCase searchNewsUseCase;
  final GetSearchHistoryUseCase getSearchHistoryUseCase;
  final SaveSearchHistoryUseCase saveSearchHistoryUseCase;
  final ClearSearchHistoryUseCase clearSearchHistoryUseCase;

  DiscoverBloc(
    this.getTrendingNewsUseCase,
    this.getSourcesUseCase,
    this.searchNewsUseCase,
    this.getSearchHistoryUseCase,
    this.saveSearchHistoryUseCase,
    this.clearSearchHistoryUseCase,
  ) : super(DiscoverInitial()) {
    on<LoadDiscoverDataEvent>(_onLoadDiscoverData);
    on<SearchDiscoverEvent>(_onSearchDiscover);
    on<ClearSearchHistoryEvent>(_onClearSearchHistory);
  }

  Future<void> _onLoadDiscoverData(
    LoadDiscoverDataEvent event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(DiscoverLoading());

    final trendingResult = await getTrendingNewsUseCase(NoParams());
    final sourcesResult = await getSourcesUseCase(NoParams());
    final historyResult = await getSearchHistoryUseCase(NoParams());

    trendingResult.fold(
      (failure) => emit(DiscoverError(_mapFailureToMessage(failure))),
      (trendingNews) {
        sourcesResult.fold(
          (failure) => emit(DiscoverError(_mapFailureToMessage(failure))),
          (sources) {
            historyResult.fold(
              (failure) => emit(DiscoverError(_mapFailureToMessage(failure))),
              (history) => emit(DiscoverLoaded(
                trendingNews: trendingNews,
                sources: sources,
                searchHistory: history,
              )),
            );
          },
        );
      },
    );
  }

  Future<void> _onSearchDiscover(
    SearchDiscoverEvent event,
    Emitter<DiscoverState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(LoadDiscoverDataEvent());
      return;
    }

    emit(DiscoverLoading());
    
    // Lưu lịch sử tìm kiếm
    await saveSearchHistoryUseCase(event.query);

    final result = await searchNewsUseCase(SearchParams(
      query: event.query,
      sortBy: event.sortBy,
      from: event.from,
      to: event.to,
    ));

    result.fold(
      (failure) => emit(DiscoverError(_mapFailureToMessage(failure))),
      (articles) => emit(DiscoverSearchLoaded(searchResults: articles)),
    );
  }

  Future<void> _onClearSearchHistory(
    ClearSearchHistoryEvent event,
    Emitter<DiscoverState> emit,
  ) async {
    await clearSearchHistoryUseCase(NoParams());
    add(LoadDiscoverDataEvent()); // Xóa xong thì load lại data để update List history
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
