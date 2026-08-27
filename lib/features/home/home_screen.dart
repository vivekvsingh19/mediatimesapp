import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/news_provider.dart';
import 'widgets/news_card.dart';
import 'widgets/ad_slot.dart';

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
      appBar: AppBar(
        title: const Text('MEDIA TIMES', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          )
        ],
      ),
      body: newsState.when(
        data: (articles) {
          if (articles.isEmpty) {
            return const Center(child: Text('No news available.'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(newsProvider(null).notifier).fetchNews(refresh: true),
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: articles.length + 1,
              onPageChanged: (index) {
                if (index == articles.length - 2) {
                  ref.read(newsProvider(null).notifier).fetchNews();
                }
              },
              itemBuilder: (context, index) {
                if (index > 0 && index % 5 == 0) {
                  return const AdSlot(position: 'feed_between_articles');
                }
                
                final adCount = index ~/ 5;
                final articleIndex = index - adCount;
                
                if (articleIndex >= articles.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final article = articles[articleIndex];
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
              const Text('Unable to load news'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(newsProvider(null).notifier).fetchNews(refresh: true),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
