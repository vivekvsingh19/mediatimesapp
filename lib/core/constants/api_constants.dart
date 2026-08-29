import 'package:dio/dio.dart';

class ApiConstants {
  static String activeDomain = 'https://themediatimes.live';

  static Future<void> init() async {
    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 2),
        receiveTimeout: const Duration(seconds: 2),
      ));
      final response = await dio.get('https://themediatimes.live/api/mobile/categories'); // Hit a fast endpoint
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 400) {
        activeDomain = 'https://themediatimes.live';
      } else {
        activeDomain = 'https://mediatimeslive.vercel.app';
      }
    } catch (e) {
      activeDomain = 'https://mediatimeslive.vercel.app';
    }
  }

  static String get baseUrl {
    return '$activeDomain/api/mobile';
  }

  static const String news = '/news';
  static const String categories = '/categories';
  static const String videos = '/videos';
  static const String search = '/search';
  static const String ads = '/ads';

  static String getFrontendArticleUrl(String slug) {
    return '$activeDomain/en/article/$slug';
  }
}
