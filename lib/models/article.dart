class ArticleCategoryTranslation {
  final String language;
  final String name;

  ArticleCategoryTranslation({required this.language, required this.name});

  factory ArticleCategoryTranslation.fromJson(Map<String, dynamic> json) {
    return ArticleCategoryTranslation(
      language: json['language'] as String,
      name: json['name'] as String,
    );
  }
}

class ArticleCategory {
  final int id;
  final String name;
  final String slug;

  final List<ArticleCategoryTranslation>? translations;

  ArticleCategory({required this.id, required this.name, required this.slug, this.translations});

  static const Map<String, Map<String, String>> _localTranslations = {
    'hi': {
      'bihar': 'बिहार',
      'business': 'व्यापार',
      'case-study': 'केस स्टडी',
      'cover-story': 'कवर स्टोरी',
      'crime': 'अपराध',
      'editorial': 'संपादकीय',
      'education': 'शिक्षा',
      'entertainment': 'मनोरंजन',
      'finance': 'वित्त',
      'health-fitness': 'स्वास्थ्य',
      'healthcare': 'स्वास्थ्य सेवा',
      'human-rights': 'मानव अधिकार',
      'international': 'अंतर्राष्ट्रीय',
      'india': 'भारत',
      'jharkhand': 'झारखंड',
      'job-career': 'नौकरी/करियर',
      'latest': 'नवीनतम',
      'legal': 'कानूनी',
      'life-style': 'जीवन शैली',
      'maharashtra': 'महाराष्ट्र',
      'online-gambling': 'ऑनलाइन जुआ',
      'other': 'अन्य',
      'politics': 'राजनीति',
      'sports': 'खेल',
      'technology': 'प्रौद्योगिकी',
      'tourism': 'पर्यटन',
      'world': 'विश्व',
      'uncategorized': 'अवर्गीकृत'
    },
    'mr': {
      'bihar': 'बिहार',
      'business': 'व्यापार',
      'case-study': 'केस स्टडी',
      'cover-story': 'कव्हर स्टोरी',
      'crime': 'गुन्हेगारी',
      'editorial': 'संपादकीय',
      'education': 'शिक्षण',
      'entertainment': 'मनोरंजन',
      'finance': 'वित्त',
      'health-fitness': 'आरोग्य',
      'healthcare': 'आरोग्य सेवा',
      'human-rights': 'मानवी हक्क',
      'international': 'आंतरराष्ट्रीय',
      'india': 'भारत',
      'jharkhand': 'झारखंड',
      'job-career': 'नोकरी/करिअर',
      'latest': 'नवीनतम',
      'legal': 'कायदेशीर',
      'life-style': 'जीवनशैली',
      'maharashtra': 'महाराष्ट्र',
      'online-gambling': 'ऑनलाइन जुगार',
      'other': 'इतर',
      'politics': 'राजकारण',
      'sports': 'क्रीडा',
      'technology': 'तंत्रज्ञान',
      'tourism': 'पर्यटन',
      'world': 'जग',
      'uncategorized': 'अवर्गीकृत'
    }
  };

  String getLocalizedName(String langCode) {
    if (langCode == 'en') return name;
    if (translations != null && translations!.isNotEmpty) {
      final translation = translations!.where((t) => t.language == langCode).firstOrNull;
      if (translation != null && translation.name.isNotEmpty) return translation.name;
    }
    return _localTranslations[langCode]?[slug.toLowerCase()] ?? name;
  }

  factory ArticleCategory.fromJson(Map<String, dynamic> json) {
    return ArticleCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      translations: (json['translations'] as List<dynamic>?)
          ?.map((e) => ArticleCategoryTranslation.fromJson(e as Map<String, dynamic>))
          .toList(),
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
