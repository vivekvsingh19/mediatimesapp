import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import 'news_provider.dart';

import 'language_provider.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final lang = ref.watch(languageProvider);
  return apiService.getCategories(lang: lang);
});
