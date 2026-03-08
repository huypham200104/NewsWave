import 'package:flutter/material.dart';
import '../../domain/entities/article_entity.dart';
import '../widgets/article_details/article_details_app_bar.dart';
import '../widgets/article_details/article_details_header.dart';
import '../widgets/article_details/article_details_content.dart';
import '../widgets/article_details/article_details_footer.dart';

class ArticleDetailsPage extends StatelessWidget {
  final ArticleEntity article;

  const ArticleDetailsPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ArticleDetailsAppBar(article: article),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArticleDetailsHeader(article: article),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  ArticleDetailsContent(article: article),
                  const SizedBox(height: 40),
                  ArticleDetailsFooter(url: article.url),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
