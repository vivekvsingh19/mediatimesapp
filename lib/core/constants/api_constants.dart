

class ApiConstants {
  static String get baseUrl {
    // 127.0.0.1 works on Web/Desktop. For physical Android devices over USB,
    // use `adb reverse tcp:3000 tcp:3000` to map this to the host machine.
    // For Android Emulators, 10.0.2.2 is usually required if adb reverse isn't active.
    return 'http://127.0.0.1:3000/api/mobile';
  }
  
  static const String news = '/news';
  static const String categories = '/categories';
  static const String videos = '/videos';
  static const String search = '/search';
  static const String ads = '/ads';
}
