class ApiConstants {
  static String get baseUrl {
    return 'https://mediatimeslive.vercel.app/api/mobile';
  }

  static const String news = '/news';
  static const String categories = '/categories';
  static const String videos = '/videos';
  static const String search = '/search';
  static const String ads = '/ads';

  static String getFrontendArticleUrl(String slug) {
    return 'https://mediatimes.live/en/article/$slug';
  }
}
