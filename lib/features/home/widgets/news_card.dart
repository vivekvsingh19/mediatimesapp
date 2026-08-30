import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import '../../../models/article.dart';
import '../../../core/constants/api_constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/bookmark_provider.dart';

class NewsCard extends ConsumerWidget {
  final Article article;

  const NewsCard({super.key, required this.article});

  String _getCleanExcerpt(String? rawExcerpt) {
    if (rawExcerpt == null) return '';
    String text = rawExcerpt;

    // Strip HTML tags
    text = text.replaceAll(RegExp(r'<[^>]*>'), '');
    
    // Replace HTML entities
    text = text.replaceAll('&nbsp;', ' ');

    // Find the first colon ':' which typically separates the publisher/category from the description
    // e.g. "द मीडिया टाइम्स डेस्क, 19 जून Bihar News : बिहार के चर्चित..."
    final colonIndex = text.indexOf(':');
    if (colonIndex != -1 && colonIndex < 100) {
      text = text.substring(colonIndex + 1);
    }

    // Collapse multiple spaces/newlines into a single space, and trim
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    // Remove leading punctuation if any (like extra commas or hyphens or dots)
    text = text.replaceFirst(RegExp(r'^[\s\.,:-]+'), '').trim();

    return text;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarkedState = ref.watch(isBookmarkedProvider(article.id));
    final isBookmarked = isBookmarkedState.value ?? false;
    return GestureDetector(
      onTap: () {
        context.push(
          '/article/webview',
          extra: ApiConstants.getFrontendArticleUrl(article.slug),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Expanded(
                flex: 45,
                child: article.featuredImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: article.featuredImageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            LucideIcons.imageOff,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[200],
                        width: double.infinity,
                        child: const Icon(
                          LucideIcons.newspaper,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
              ),

              // Content Section
              Expanded(
                flex: 55,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Publisher Bar
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.newspaper,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'The Media Times',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: Colors.grey[800],
                              letterSpacing: -0.5,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : LucideIcons.bookmark,
                              size: 22,
                              color: isBookmarked
                                  ? Theme.of(context).primaryColor
                                  : Colors.black54,
                            ),
                            onPressed: () async {
                              final service = ref.read(bookmarkServiceProvider);
                              if (isBookmarked) {
                                await service.removeBookmark(article.id);
                              } else {
                                await service.saveBookmark(article);
                              }
                              ref.invalidate(isBookmarkedProvider(article.id));
                              ref.invalidate(bookmarksProvider);
                            },
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          IconButton(
                            icon: const Icon(
                              LucideIcons.share2,
                              size: 22,
                              color: Colors.black54,
                            ),
                            onPressed: () {
                              final url = ApiConstants.getFrontendArticleUrl(
                                article.slug,
                              );
                              Share.share(
                                'Check out this article: ${article.title}\n\n$url',
                              );
                            },
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                          color: Colors.black87,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      // Description / Content
                      if (article.content != null || article.excerpt != null)
                        Expanded(
                          child: Text(
                            _getCleanExcerpt(article.content ?? article.excerpt),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else
                        const Spacer(),

                      const SizedBox(height: 16),

                      // Footer
                      Text(
                        '${article.publishedAt != null ? timeago.format(DateTime.parse(article.publishedAt!)) : 'Unknown'} • ${article.author?.name ?? 'The Media Times'}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
