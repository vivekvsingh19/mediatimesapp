class ArticleCategory {
  final int id;
  final String name;
  final String slug;

  ArticleCategory({required this.id, required this.name, required this.slug});

  factory ArticleCategory.fromJson(Map<String, dynamic> json) {
    return ArticleCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );
  }
}

class ArticleAuthor {
  final String name;

  ArticleAuthor({required this.name});

  factory ArticleAuthor.fromJson(Map<String, dynamic> json) {
    return ArticleAuthor(
      name: json['name'] as String,
    );
  }
}

class ArticleTranslation {
  final String language;
  final String title;
  final String? excerpt;
  final String? content;

  ArticleTranslation({
    required this.language,
    required this.title,
    this.excerpt,
    this.content,
  });

  factory ArticleTranslation.fromJson(Map<String, dynamic> json) {
    return ArticleTranslation(
      language: json['language'] as String,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String?,
      content: json['content'] as String?,
    );
  }
}

class Article {
  final int id;
  final String title;
  final String slug;
  final String? excerpt;
  final String? content;
  final String? featuredImageUrl;
  final String? publishedAt;
  final bool isBreaking;
  final ArticleCategory? category;
  final ArticleAuthor? author;
  final List<Article>? relatedArticles;
  final List<ArticleTranslation>? translations;

  Article({
    required this.id,
    required this.title,
    required this.slug,
    this.excerpt,
    this.content,
    this.featuredImageUrl,
    this.publishedAt,
    this.isBreaking = false,
    this.category,
    this.author,
    this.relatedArticles,
    this.translations,
  });

  String getLocalizedTitle(String langCode) {
    if (langCode == 'en' || translations == null || translations!.isEmpty) return title;
    final translation = translations!.where((t) => t.language == langCode).firstOrNull;
    return translation?.title ?? title;
  }

  String? getLocalizedExcerpt(String langCode) {
    if (langCode == 'en' || translations == null || translations!.isEmpty) return excerpt;
    final translation = translations!.where((t) => t.language == langCode).firstOrNull;
    return translation?.excerpt ?? excerpt;
  }

  String? getLocalizedContent(String langCode) {
    if (langCode == 'en' || translations == null || translations!.isEmpty) return content;
    final translation = translations!.where((t) => t.language == langCode).firstOrNull;
    return translation?.content ?? content;
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,
      title: json['title'] as String,
      slug: json['slug'] as String,
      excerpt: json['excerpt'] as String?,
      content: json['content'] as String?,
      featuredImageUrl: json['featuredImageUrl'] as String?,
      publishedAt: json['publishedAt'] as String?,
      isBreaking: json['isBreaking'] as bool? ?? false,
      category: json['category'] != null
          ? ArticleCategory.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      author: json['author'] != null
          ? ArticleAuthor.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      relatedArticles: (json['relatedArticles'] as List<dynamic>?)
          ?.map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList(),
      translations: (json['translations'] as List<dynamic>?)
          ?.map((e) => ArticleTranslation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
