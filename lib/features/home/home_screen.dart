import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/news_provider.dart';
import '../../providers/categories_provider.dart';
import 'widgets/news_card.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider(null));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: ref.watch(categoriesProvider).when(
          data: (categories) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((c) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: GestureDetector(
                  onTap: () => context.push('/category/${c.slug}', extra: c.name),
                  child: Text(
                    c.name,
                    style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              )).toList(),
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
            onRefresh: () =>
                ref.read(newsProvider(null).notifier).fetchNews(refresh: true),
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: articles.length + 1,
              onPageChanged: (index) {
                // Trigger fetch when 2 cards away since we load 5 at a time
                if (index >= articles.length - 2) {
                  ref.read(newsProvider(null).notifier).fetchNews();
                }
              },
              itemBuilder: (context, index) {
                if (index >= articles.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Preload the next 3 articles' images for maximum smoothness
                for (int i = 1; i <= 3; i++) {
                  if (index + i < articles.length) {
                    final nextArticle = articles[index + i];
                    if (nextArticle.featuredImageUrl != null) {
                      precacheImage(
                        CachedNetworkImageProvider(nextArticle.featuredImageUrl!),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Unable to load news: $err', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(newsProvider(null).notifier)
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
