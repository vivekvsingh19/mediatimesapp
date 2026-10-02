import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/bookmark_provider.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/language_provider.dart';

import 'package:lucide_icons/lucide_icons.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(languageProvider);
    final bookmarksState = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(AppStrings.get(currentLang, 'saved'), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: bookmarksState.when(
        data: (bookmarks) {
          if (bookmarks.isEmpty) {
            return Center(child: Text(AppStrings.get(currentLang, 'no_saved')));
          }
          return ListView.separated(
            itemCount: bookmarks.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final article = bookmarks[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  article.getLocalizedTitle(currentLang),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: article.category != null ? Text(article.category!.getLocalizedName(currentLang)) : null,
                trailing: IconButton(
                  icon: const Icon(LucideIcons.trash2),
                  onPressed: () async {
                    await ref.read(bookmarkServiceProvider).removeBookmark(article.id);
                    ref.invalidate(bookmarksProvider);
                  },
                ),
                onTap: () {
                  context.push('/article/webview', extra: ApiConstants.getFrontendArticleUrl(article.slug, currentLang));
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('${AppStrings.get(currentLang, 'error')}$err')),
      ),
    );
  }
}
