import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/bookmark_provider.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/language_provider.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(languageProvider);
    final bookmarksState = ref.watch(bookmarksProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          AppStrings.get(currentLang, 'saved').toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
          child: bookmarksState.when(
            data: (bookmarks) {
              if (bookmarks.isEmpty) {
                return Center(
                  child: Text(AppStrings.get(currentLang, 'no_saved')),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.only(top: 16, bottom: 24),
                itemCount: bookmarks.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final article = bookmarks[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      article.getLocalizedTitle(currentLang),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        height: 1.25,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    subtitle: article.category != null
                        ? Text(article.category!.getLocalizedName(currentLang))
                        : null,
                    trailing: IconButton(
                      icon: const Icon(LucideIcons.trash2),
                      onPressed: () async {
                        await ref
                            .read(bookmarkServiceProvider)
                            .removeBookmark(article.id);
                        ref.invalidate(bookmarksProvider);
                      },
                    ),
                    onTap: () {
                      context.push(
                        '/article/webview',
                        extra: ApiConstants.getFrontendArticleUrl(
                          article.slug,
                          currentLang,
                        ),
                      );
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text('${AppStrings.get(currentLang, 'error')}$err'),
            ),
          ),
        ),
      ),
    );
  }
}
