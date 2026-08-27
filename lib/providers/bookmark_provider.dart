import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article.dart';
import '../services/bookmark_service.dart';

final bookmarkServiceProvider = Provider((ref) => BookmarkService());

final bookmarksProvider = FutureProvider<List<Article>>((ref) async {
  final service = ref.read(bookmarkServiceProvider);
  return service.getBookmarks();
});

final isBookmarkedProvider = FutureProvider.family<bool, int>((ref, articleId) async {
  final service = ref.read(bookmarkServiceProvider);
  return service.isBookmarked(articleId);
});
