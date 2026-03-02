import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../bloc/discover/discover_bloc.dart';
import '../../bloc/discover/discover_event.dart';

class DiscoverCategoriesGrid extends StatelessWidget {
  const DiscoverCategoriesGrid({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'id': 'business',
      'name': 'Business',
      'icon': '💼',
      'colors': [Color(0xFF4A00E0), Color(0xFF8E2DE2)]
    },
    {
      'id': 'entertainment',
      'name': 'Entertainment',
      'icon': '🎬',
      'colors': [Color(0xFFFF416C), Color(0xFFFF4B2B)]
    },
    {
      'id': 'health',
      'name': 'Health',
      'icon': '🏥',
      'colors': [Color(0xFF11998E), Color(0xFF38EF7D)]
    },
    {
      'id': 'science',
      'name': 'Science',
      'icon': '🔬',
      'colors': [Color(0xFF2193b0), Color(0xFF6dd5ed)]
    },
    {
      'id': 'sports',
      'name': 'Sports',
      'icon': '⚽',
      'colors': [Color(0xFFF2994A), Color(0xFFF2C94C)]
    },
    {
      'id': 'technology',
      'name': 'Technology',
      'icon': '💻',
      'colors': [Color(0xFF0F2027), Color(0xFF203A43)]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final List<Color> bgColors = category['colors'] as List<Color>;
            
            return InkWell(
              onTap: () {
                final categoryName = category['name'] as String;
                context.read<DiscoverBloc>().add(SearchDiscoverEvent(query: categoryName));
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: bgColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [], // Shadow removed as requested
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned(
                      right: -15,
                      bottom: -15,
                      child: Transform.rotate(
                        angle: -0.2,
                        child: Text(
                          category['icon'] as String,
                          style: TextStyle(
                            fontSize: 80,
                            color: Colors.white.withAlpha(40), // Transparent icon in background
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(60),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              category['icon'] as String,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          Text(
                            category['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ]
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
