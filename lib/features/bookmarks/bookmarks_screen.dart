import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/bookmark_provider.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/language_provider.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

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
              return ListView.builder(
                padding: const EdgeInsets.only(top: 16, bottom: 24),
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  final article = bookmarks[index];
                  return GestureDetector(
                    onTap: () {
                      context.push(
                        '/article/webview',
                        extra: ApiConstants.getFrontendArticleUrl(
                          article.slug,
                          currentLang,
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                            child: article.featuredImageUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: article.featuredImageUrl!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      width: 120,
                                      height: 120,
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      width: 120,
                                      height: 120,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.error),
                                    ),
                                  )
                                : Container(
                                    width: 120,
                                    height: 120,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                  ),
                          ),
                          // Content
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Category
                                  if (article.category != null)
                                    Text(
                                      article.category!.getLocalizedName(currentLang).toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  const SizedBox(height: 6),
                                  // Title
                                  Text(
                                    article.getLocalizedTitle(currentLang),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Theme.of(context).textTheme.titleLarge?.color,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Footer
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          article.publishedAt != null
                                              ? timeago.format(DateTime.parse(article.publishedAt!), locale: currentLang)
                                              : '',
                                          style: TextStyle(
                                            color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await ref
                                              .read(bookmarkServiceProvider)
                                              .removeBookmark(article.id);
                                          ref.invalidate(bookmarksProvider);
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(
                                            LucideIcons.trash2,
                                            size: 18,
                                            color: Colors.red[400],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
