import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/news_bloc.dart';
import '../widgets/home/featured_section.dart';
import '../widgets/home/home_greeting.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/main_news_section.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<NewsBloc>().add(GetTopHeadlinesEvent());
          },
          child: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(),
                HomeGreeting(),
                FeaturedSection(),
                MainNewsSection(),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

