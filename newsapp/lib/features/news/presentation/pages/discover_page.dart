import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/discover/discover_bloc.dart';
import '../bloc/discover/discover_event.dart';
import '../bloc/discover/discover_state.dart';
import '../widgets/discover/discover_search_bar.dart';
import '../widgets/discover/discover_trending_section.dart';
import '../widgets/discover/discover_categories_grid.dart';
import '../widgets/discover/discover_sources_section.dart';
import '../widgets/discover/discover_search_results.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DiscoverBloc>()..add(LoadDiscoverDataEvent()),
      child: const DiscoverView(),
    );
  }
}

class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                'Discover',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'News from around the world',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DiscoverSearchBar(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<DiscoverBloc, DiscoverState>(
                builder: (context, state) {
                  if (state is DiscoverLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DiscoverError) {
                    return Center(child: Text(state.message));
                  } else if (state is DiscoverSearchLoaded) {
                    return DiscoverSearchResults(results: state.searchResults);
                  } else if (state is DiscoverLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<DiscoverBloc>().add(LoadDiscoverDataEvent());
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DiscoverTrendingSection(trendingNews: state.trendingNews),
                            const SizedBox(height: 24),
                            const DiscoverCategoriesGrid(),
                            const SizedBox(height: 24),
                            DiscoverSourcesSection(sources: state.sources),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
