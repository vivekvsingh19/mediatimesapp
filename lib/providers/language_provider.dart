import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in ProviderScope');
});

class LanguageNotifier extends Notifier<String> {
  static const _langKey = 'app_language';

  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(_langKey) ?? 'en';
  }

  Future<void> setLanguage(String langCode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_langKey, langCode);
    state = langCode;
  }
}

final languageProvider = NotifierProvider<LanguageNotifier, String>(() {
  return LanguageNotifier();
});
