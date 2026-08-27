import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/article.dart';
import '../../../core/constants/api_constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsCard extends StatelessWidget {
  final Article article;

  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/article/webview', extra: ApiConstants.getFrontendArticleUrl(article.slug));
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageHeight = constraints.maxHeight * 0.45 + 32;
          final textTop = constraints.maxHeight * 0.45;
          
          return Stack(
            children: [
              // Image Section
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: imageHeight,
                child: article.featuredImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: article.featuredImageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(LucideIcons.imageOff, size: 50, color: Colors.grey),
                        ),
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(LucideIcons.newspaper, size: 80, color: Colors.grey),
                      ),
              ),

              // Content Section
              Positioned(
                top: textTop,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
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
                              child: const Icon(LucideIcons.newspaper, color: Colors.white, size: 14),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Media Times',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: Colors.grey[800],
                                letterSpacing: -0.5,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(LucideIcons.bookmark, size: 22, color: Colors.black54),
                              onPressed: () {}, 
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            IconButton(
                              icon: const Icon(LucideIcons.share2, size: 22, color: Colors.black54),
                              onPressed: () {},
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
                        
                        // Excerpt
                        if (article.excerpt != null)
                          Expanded(
                            child: Text(
                              article.excerpt!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 7,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        else
                          const Spacer(),

                        const SizedBox(height: 16),
                        
                        // Footer
                        Text(
                          '${article.publishedAt != null ? timeago.format(DateTime.parse(article.publishedAt!)) : 'Unknown'} • ${article.author?.name ?? 'Media Times'}',
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
              ),
            ],
          );
        },
      ),
    );
  }
}
