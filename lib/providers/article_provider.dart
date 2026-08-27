import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article.dart';
import 'news_provider.dart';

final articleDetailsProvider = FutureProvider.family<Article, String>((ref, slug) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.getArticleDetails(slug);
});
