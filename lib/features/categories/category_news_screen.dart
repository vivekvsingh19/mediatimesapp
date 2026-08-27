import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/news_provider.dart';
import '../home/widgets/news_card.dart';

class CategoryNewsScreen extends ConsumerStatefulWidget {
  final String categorySlug;
  final String categoryName;

  const CategoryNewsScreen({
    super.key,
    required this.categorySlug,
    required this.categoryName,
  });

  @override
  ConsumerState<CategoryNewsScreen> createState() => _CategoryNewsScreenState();
}

class _CategoryNewsScreenState extends ConsumerState<CategoryNewsScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider(widget.categorySlug));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.categoryName.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: newsState.when(
        data: (articles) {
          if (articles.isEmpty) {
            return const Center(child: Text('No news available in this category.'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(newsProvider(widget.categorySlug).notifier).fetchNews(refresh: true),
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: articles.length + 1,
              onPageChanged: (index) {
                if (index == articles.length - 1) {
                  ref.read(newsProvider(widget.categorySlug).notifier).fetchNews();
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
                onPressed: () => ref.read(newsProvider(widget.categorySlug).notifier).fetchNews(refresh: true),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
