import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/news_bloc.dart';
import 'article_list_tile.dart';

class MainNewsSection extends StatelessWidget {
  const MainNewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Main',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ),
        BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsLoaded) {
              final mainArticles = state.articles.skip(5).toList();
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mainArticles.length,
                itemBuilder: (context, index) {
                  return ArticleListTile(article: mainArticles[index]);
                },
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
