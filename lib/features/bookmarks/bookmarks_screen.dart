import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/bookmark_provider.dart';
import '../../core/constants/api_constants.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksState = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SAVED', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: true,
      ),
      body: bookmarksState.when(
        data: (bookmarks) {
          if (bookmarks.isEmpty) {
            return const Center(child: Text('No saved articles.'));
          }
          return ListView.separated(
            itemCount: bookmarks.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final article = bookmarks[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: article.category != null ? Text(article.category!.name) : null,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    await ref.read(bookmarkServiceProvider).removeBookmark(article.id);
                    ref.invalidate(bookmarksProvider);
                  },
                ),
                onTap: () async {
                  final url = Uri.parse(ApiConstants.getFrontendArticleUrl(article.slug));
                  if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not open article')),
                      );
                    }
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
