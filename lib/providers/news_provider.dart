import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());

class NewsNotifier extends StateNotifier<AsyncValue<List<Article>>> {
  final ApiService apiService;
  final String? category;
  int _page = 1;
  bool _hasMore = true;
  List<Article> _articles = [];

  NewsNotifier(this.apiService, {this.category}) : super(const AsyncValue.loading()) {
    fetchNews();
  }

  Future<void> fetchNews({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
      _articles = [];
      state = const AsyncValue.loading();
    }

    if (!_hasMore && !refresh) return;

    try {
      final newArticles = await apiService.getNews(page: _page, category: category);
      if (newArticles.isEmpty) {
        _hasMore = false;
      } else {
        _page++;
        _articles.addAll(newArticles);
      }
      state = AsyncValue.data(List.from(_articles));
    } catch (e, st) {
      if (_articles.isEmpty) {
        state = AsyncValue.error(e, st);
      }
    }
  }
}

final newsProvider = StateNotifierProvider.family<NewsNotifier, AsyncValue<List<Article>>, String?>((ref, category) {
  return NewsNotifier(ref.read(apiServiceProvider), category: category);
});
