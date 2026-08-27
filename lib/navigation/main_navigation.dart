import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/navigation/main_scaffold.dart';
import '../features/home/home_screen.dart';
import '../features/categories/categories_screen.dart';
import '../features/categories/category_news_screen.dart';
import '../features/bookmarks/bookmarks_screen.dart';
import '../features/article/article_webview_screen.dart';

import '../features/search/search_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/categories',
            builder: (context, state) => const CategoriesScreen(),
          ),
          GoRoute(
            path: '/bookmarks',
            builder: (context, state) => const BookmarksScreen(),
          ),
        ],
      ),

      GoRoute(
        path: '/article/webview',
        builder: (context, state) {
          final url = state.extra as String;
          return ArticleWebViewScreen(url: url);
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/category/:slug',
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          final name = state.extra as String? ?? 'Category';
          return CategoryNewsScreen(categorySlug: slug, categoryName: name);
        },
      ),
    ],
  );
});
