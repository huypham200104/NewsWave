import 'package:flutter/material.dart';
import '../../../domain/entities/article_entity.dart';
import 'discover_article_card.dart';

class DiscoverTrendingSection extends StatelessWidget {
  final List<ArticleEntity> trendingNews;

  const DiscoverTrendingSection({super.key, required this.trendingNews});

  @override
  Widget build(BuildContext context) {
    if (trendingNews.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trending',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View all'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 260,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 16),
            scrollDirection: Axis.horizontal,
            itemCount: trendingNews.length > 10 ? 10 : trendingNews.length,
            itemBuilder: (context, index) {
              return DiscoverArticleCard(article: trendingNews[index]);
            },
          ),
        ),
      ],
    );
  }
}
