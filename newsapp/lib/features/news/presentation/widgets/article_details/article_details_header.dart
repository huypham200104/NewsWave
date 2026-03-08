import 'package:flutter/material.dart';
import '../../../domain/entities/article_entity.dart';

class ArticleDetailsHeader extends StatelessWidget {
  final ArticleEntity article;

  const ArticleDetailsHeader({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.source, size: 16, color: Colors.blueAccent),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                Uri.tryParse(article.url)?.host.replaceAll('www.', '') ?? 'News Source',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.access_time, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            Text(
              article.publishedAt.toString().substring(0, 16).replaceAll('T', ' '),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        if (article.author != null && article.author!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  article.author!,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
