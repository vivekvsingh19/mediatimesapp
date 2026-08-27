import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:3000/api/mobile';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api/mobile';
    }
    return 'http://127.0.0.1:3000/api/mobile';
  }
  
  static const String news = '/news';
  static const String categories = '/categories';
  static const String videos = '/videos';
  static const String search = '/search';
  static const String ads = '/ads';
}
