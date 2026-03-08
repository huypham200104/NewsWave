import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/entities/article_entity.dart';
import '../../bloc/bookmark/bookmark_bloc.dart';
import '../../bloc/bookmark/bookmark_event.dart';
import '../../bloc/bookmark/bookmark_state.dart';

class ArticleDetailsAppBar extends StatelessWidget {
  final ArticleEntity article;

  const ArticleDetailsAppBar({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250.0,
      pinned: true,
      actions: [
        BlocBuilder<BookmarkBloc, BookmarkState>(
          builder: (context, state) {
            bool isBookmarked = false;
            if (state is BookmarkLoaded) {
              isBookmarked = state.bookmarks.any((b) => b.url == article.url);
            }
            return IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked ? Colors.blueAccent : Colors.white,
              ),
              onPressed: () {
                context.read<BookmarkBloc>().add(ToggleBookmarkEvent(article));
              },
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: article.urlToImage != null && article.urlToImage!.isNotEmpty
            ? Hero(
                tag: article.urlToImage!,
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => _buildPlaceholder(),
                ),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.image, size: 50, color: Colors.grey),
      ),
    );
  }
}
