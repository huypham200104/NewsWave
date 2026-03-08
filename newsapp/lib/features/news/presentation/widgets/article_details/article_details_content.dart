import 'package:flutter/material.dart';
import '../../../domain/entities/article_entity.dart';

class ArticleDetailsContent extends StatelessWidget {
  final ArticleEntity article;

  const ArticleDetailsContent({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (article.description != null && article.description!.isNotEmpty) ...[
          Text(
            article.description!,
            style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
        ],
        if (article.content != null && article.content!.isNotEmpty) ...[
          Text(
            article.content!,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ] else ...[
          const Text(
            'No detailed content available for this article.',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.grey,
            ),
          ),
        ],
      ],
    );
  }
}
