import 'package:dio/dio.dart';

class ApiConstants {
  static String activeDomain = 'https://themediatimes.live';

  static Future<void> init() async {
    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ));
      
      // Try local dev server first (for Desktop/Web)
      try {
        final localResponse = await dio.get('http://localhost:3000/api/mobile/categories');
        if (localResponse.statusCode != null && localResponse.statusCode! >= 200 && localResponse.statusCode! < 400) {
          activeDomain = 'http://localhost:3000';
          return;
        }
      } catch (_) {}

      // Try Android Emulator local server
      try {
        final androidLocalResponse = await dio.get('http://10.0.2.2:3000/api/mobile/categories');
        if (androidLocalResponse.statusCode != null && androidLocalResponse.statusCode! >= 200 && androidLocalResponse.statusCode! < 400) {
          activeDomain = 'http://10.0.2.2:3000';
          return;
        }
      } catch (_) {}
      
      // Default to live domain if local fails
      activeDomain = 'https://themediatimes.live';
    } catch (e) {
      activeDomain = 'https://themediatimes.live';
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

  static String getFrontendArticleUrl(String slug, String lang) {
    return '$activeDomain/$lang/article/$slug';
  }
}
