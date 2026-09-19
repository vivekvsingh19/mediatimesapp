import '../core/network/api_client.dart';
import '../core/constants/api_constants.dart';
import '../models/article.dart';
import '../models/category.dart';
import '../models/video.dart';

class ApiService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Article>> getNews({
    int page = 1,
    int limit = 10,
    String? category,
    String lang = 'en',
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.news,
        queryParameters: {
          'page': page, 
          'limit': limit, 
          'lang': lang,
          if (category != null) 'category': category
        },
      );

      final data = response.data['data'] as List;
      return data
          .map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  Future<Article> getArticleDetails(String slug, {String lang = 'en'}) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.news}/$slug', queryParameters: {'lang': lang});
      return Article.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load article details: $e');
    }
  }

  Future<List<Category>> getCategories({String lang = 'en'}) async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.categories, queryParameters: {'lang': lang});
      final data = response.data as List;
      return data
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<List<Video>> getVideos({int page = 1, int limit = 10, String lang = 'en'}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.videos,
        queryParameters: {'page': page, 'limit': limit, 'lang': lang},
      );

      final data = response.data['data'] as List;
      return data
          .map((e) => Video.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load videos: $e');
    }
  }

  Future<List<Article>> searchNews(
    String query, {
    int page = 1,
    int limit = 10,
    String lang = 'en',
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.search,
        queryParameters: {'q': query, 'page': page, 'limit': limit, 'lang': lang},
      );

      final data = response.data['data'] as List;
      return data
          .map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search news: $e');
    }
  }
}
