import 'package:flutter/material.dart';
import '../../../domain/entities/article_entity.dart';
import '../article_list_tile.dart';

class DiscoverSearchResults extends StatelessWidget {
  final List<ArticleEntity> results;

  const DiscoverSearchResults({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'No results found.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
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
