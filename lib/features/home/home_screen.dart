import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/news_provider.dart';
import '../../providers/categories_provider.dart';
import 'widgets/news_card.dart';
import 'widgets/news_card_skeleton.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();
  String? _selectedCategorySlug;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider(_selectedCategorySlug));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: ref
            .watch(categoriesProvider)
            .when(
              data: (categories) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategorySlug = null;
                          });
                          if (_pageController.hasClients)
                            _pageController.jumpToPage(0);
                        },
                        child: Text(
                          'All',
                          style: TextStyle(
                            color: _selectedCategorySlug == null
                                ? Colors.red
                                : Colors.white70,
                            fontSize: 16,
                            fontWeight: _selectedCategorySlug == null
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    ...categories.map((c) {
                      final isSelected = _selectedCategorySlug == c.slug;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategorySlug = c.slug;
                            });
                            if (_pageController.hasClients)
                              _pageController.jumpToPage(0);
                          },
                          child: Text(
                            c.name,
                            style: TextStyle(
                              color: isSelected ? Colors.red : Colors.white70,
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
        centerTitle: false,
      ),
      body: newsState.when(
        data: (articles) {
          if (articles.isEmpty) {
            return const Center(child: Text('No news available.'));
          }
          return RefreshIndicator(
            onRefresh: () => ref
                .read(newsProvider(_selectedCategorySlug).notifier)
                .fetchNews(refresh: true),
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: articles.length + 1,
              onPageChanged: (index) {
                // Trigger fetch when 2 cards away since we load 5 at a time
                if (index >= articles.length - 2) {
                  ref
                      .read(newsProvider(_selectedCategorySlug).notifier)
                      .fetchNews();
                }
              },
              itemBuilder: (context, index) {
                if (index >= articles.length) {
                  return const NewsCardSkeleton();
                }

                // Preload the next 3 articles' images for maximum smoothness
                for (int i = 1; i <= 3; i++) {
                  if (index + i < articles.length) {
                    final nextArticle = articles[index + i];
                    if (nextArticle.featuredImageUrl != null) {
                      precacheImage(
                        CachedNetworkImageProvider(
                          nextArticle.featuredImageUrl!,
                        ),
                        context,
                      );
                    }
                  }
                }

                final article = articles[index];
                return NewsCard(article: article);
              },
            ),
          );
        },
        loading: () => const NewsCardSkeleton(),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Unable to load news: $err', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(newsProvider(_selectedCategorySlug).notifier)
                    .fetchNews(refresh: true),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
