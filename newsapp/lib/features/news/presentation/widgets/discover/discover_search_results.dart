import 'package:flutter/material.dart';
import '../../../domain/entities/article_entity.dart';
import '../article/article_list_tile.dart';

class DiscoverSearchResults extends StatelessWidget {
  final List<ArticleEntity> results;

  const DiscoverSearchResults({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey.withAlpha(150)),
              const SizedBox(height: 16),
              const Text(
                'No results found.',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We couldn\'t find any news for this category or search query.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            'Search results (${results.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return ArticleListTile(article: results[index]);
            },
          ),
        ),
      ],
    );
  }
}
