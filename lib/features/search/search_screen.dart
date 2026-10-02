import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/search_provider.dart';
import '../../providers/language_provider.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_strings.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _query = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = ref.watch(languageProvider);
    final searchState = ref.watch(searchProvider(_query));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: AppStrings.get(currentLang, 'search_hint'),
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                setState(() {
                  _query = '';
                });
              },
            ),
        ],
      ),
      body: _query.isEmpty
          ? Center(child: Text(AppStrings.get(currentLang, 'enter_search')))
          : searchState.when(
              data: (articles) {
                if (articles.isEmpty) {
                  return Center(child: Text(AppStrings.get(currentLang, 'no_results')));
                }
                return ListView.separated(
                  itemCount: articles.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return ListTile(
                      title: Text(
                        article.getLocalizedTitle(currentLang),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: article.category != null ? Text(article.category!.name) : null,
                      onTap: () {
                        context.push('/article/webview', extra: ApiConstants.getFrontendArticleUrl(article.slug));
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
