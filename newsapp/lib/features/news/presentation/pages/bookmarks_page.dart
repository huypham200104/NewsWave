import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bookmark/bookmark_bloc.dart';
import '../bloc/bookmark/bookmark_event.dart';
import '../bloc/bookmark/bookmark_state.dart';
import '../widgets/article/article_list_tile.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: BlocBuilder<BookmarkBloc, BookmarkState>(
        builder: (context, state) {
          if (state is BookmarkLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookmarkLoaded) {
            if (state.bookmarks.isEmpty) {
              return const Center(
                child: Text(
                  'No saved articles yet.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              itemCount: state.bookmarks.length,
              itemBuilder: (context, index) {
                final article = state.bookmarks[index];
                return Dismissible(
                  key: Key(article.url),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    context.read<BookmarkBloc>().add(RemoveBookmarkEvent(article.url));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bookmark removed.')),
                    );
                  },
                  child: ArticleListTile(article: article),
                );
              },
            );
          } else if (state is BookmarkError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No saved articles yet.'));
        },
      ),
    );
  }
}
