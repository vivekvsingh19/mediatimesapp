import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';

class BookmarkService {
  static const String _key = 'bookmarks';

  Future<void> saveBookmark(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList(_key) ?? [];
    
    final exists = bookmarks.any((b) => jsonDecode(b)['id'] == article.id);
    if (!exists) {
      final map = {
        'id': article.id,
        'title': article.title,
        'slug': article.slug,
        'excerpt': article.excerpt,
        'featuredImageUrl': article.featuredImageUrl,
        'publishedAt': article.publishedAt,
        'category': article.category != null ? {'id': article.category!.id, 'name': article.category!.name, 'slug': article.category!.slug} : null,
      };
      bookmarks.add(jsonEncode(map));
      await prefs.setStringList(_key, bookmarks);
    }
  }

  Future<void> removeBookmark(int articleId) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList(_key) ?? [];
    
    bookmarks.removeWhere((b) => jsonDecode(b)['id'] == articleId);
    await prefs.setStringList(_key, bookmarks);
  }

  Future<List<Article>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList(_key) ?? [];
    
    return bookmarks.map((b) => Article.fromJson(jsonDecode(b))).toList();
  }
  
  Future<bool> isBookmarked(int articleId) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList(_key) ?? [];
    return bookmarks.any((b) => jsonDecode(b)['id'] == articleId);
  }
}
