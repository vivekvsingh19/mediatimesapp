import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/news_provider.dart';
import 'widgets/news_card.dart';


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
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(LucideIcons.newspaper, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text(
              'MEDIA TIMES', 
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5, fontSize: 18)
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
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
                if (index == articles.length - 1) {
                  ref.read(newsProvider(null).notifier).fetchNews();
                }
              },
              itemBuilder: (context, index) {
                if (index >= articles.length) {
                  return const Center(child: CircularProgressIndicator());
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
