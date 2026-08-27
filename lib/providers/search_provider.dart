import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article.dart';
import 'news_provider.dart';

final searchProvider = FutureProvider.family<List<Article>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final apiService = ref.read(apiServiceProvider);
  return apiService.searchNews(query);
});
