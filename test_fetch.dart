import 'dart:io';
import 'package:dio/dio.dart';

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
  });

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
    );
  }
}

void main() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000/api/mobile',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  try {
    print("Fetching news...");
    final response = await dio.get('/news');
    print("Data type: \${response.data.runtimeType}");
    final data = response.data['data'] as List;
    final articles = data
        .map((e) => Article.fromJson(e as Map<String, dynamic>))
        .toList();
    print("Success: \${articles.length} articles parsed.");
  } catch (e, stack) {
    print("Error: \$e");
    print(stack);
  }
}
