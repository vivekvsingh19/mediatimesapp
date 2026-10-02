import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'navigation/main_navigation.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'providers/language_provider.dart';

// Create a provider for the cache store
final cacheStoreProvider = Provider<HiveCacheStore>((ref) {
  throw UnimplementedError('cacheStoreProvider must be overridden');
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiConstants.init();
  final prefs = await SharedPreferences.getInstance();
  final dir = await getApplicationDocumentsDirectory();
  final cacheStore = HiveCacheStore(dir.path);
  
  timeago.setLocaleMessages('hi', timeago.HiMessages());
  // Timeago might not have native Marathi, so we'll fallback to Hindi/English or use a custom one if needed.
  // We'll set 'mr' to 'hi' messages as a close placeholder or let it fallback to English.
  // Wait, let's create a quick custom MrMessages!
  timeago.setLocaleMessages('mr', _MrMessages());

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        cacheStoreProvider.overrideWithValue(cacheStore),
      ],
      child: const MediaTimesApp(),
    ),
  );
}

class MediaTimesApp extends ConsumerWidget {
  const MediaTimesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Media Times',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class _MrMessages implements timeago.LookupMessages {
  @override String prefixAgo() => '';
  @override String prefixFromNow() => '';
  @override String suffixAgo() => 'पूर्वी';
  @override String suffixFromNow() => 'नंतर';
  @override String lessThanOneMinute(int seconds) => 'काही क्षणां';
  @override String aboutAMinute(int minutes) => 'एक मिनिटा';
  @override String minutes(int minutes) => '$minutes मिनिटां';
  @override String aboutAnHour(int minutes) => 'एक तासा';
  @override String hours(int hours) => '$hours तासां';
  @override String aDay(int hours) => 'एक दिवसा';
  @override String days(int days) => '$days दिवसां';
  @override String aboutAMonth(int days) => 'एक महिन्या';
  @override String months(int months) => '$months महिन्यां';
  @override String aboutAYear(int year) => 'एक वर्षा';
  @override String years(int years) => '$years वर्षां';
  @override String wordSeparator() => ' ';
}
