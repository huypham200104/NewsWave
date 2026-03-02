import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/get_bookmarks_usecase.dart';
import '../../../domain/usecases/save_bookmark_usecase.dart';
import '../../../domain/usecases/remove_bookmark_usecase.dart';
import '../../../domain/usecases/check_bookmark_usecase.dart';
import '../../../domain/usecases/usecase.dart';

import 'bookmark_event.dart';
import 'bookmark_state.dart';

@injectable
class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final GetBookmarksUseCase getBookmarksUseCase;
  final SaveBookmarkUseCase saveBookmarkUseCase;
  final RemoveBookmarkUseCase removeBookmarkUseCase;
  final CheckBookmarkUseCase checkBookmarkUseCase;

  BookmarkBloc(
    this.getBookmarksUseCase,
    this.saveBookmarkUseCase,
    this.removeBookmarkUseCase,
    this.checkBookmarkUseCase,
  ) : super(BookmarkInitial()) {
    on<LoadBookmarksEvent>(_onLoadBookmarks);
    on<ToggleBookmarkEvent>(_onToggleBookmark);
    on<RemoveBookmarkEvent>(_onRemoveBookmark);
  }

  Future<void> _onLoadBookmarks(
    LoadBookmarksEvent event,
    Emitter<BookmarkState> emit,
  ) async {
    emit(BookmarkLoading());
    final result = await getBookmarksUseCase(NoParams());
    
    result.fold(
      (failure) => emit(const BookmarkError('Failed to load bookmarks')),
      (bookmarks) => emit(BookmarkLoaded(bookmarks)),
    );
  }

  Future<void> _onToggleBookmark(
    ToggleBookmarkEvent event,
    Emitter<BookmarkState> emit,
  ) async {
    final checkResult = await checkBookmarkUseCase(event.article.url);
    bool isBookmarked = false;
    checkResult.fold(
      (failure) {},
      (result) => isBookmarked = result,
    );
    
    if (isBookmarked) {
      await removeBookmarkUseCase(event.article.url);
    } else {
      await saveBookmarkUseCase(event.article);
    }
    
    // Refresh bookmarks list
    add(LoadBookmarksEvent());
  }

  Future<void> _onRemoveBookmark(
    RemoveBookmarkEvent event,
    Emitter<BookmarkState> emit,
  ) async {
    await removeBookmarkUseCase(event.url);
    add(LoadBookmarksEvent());
  }
}
