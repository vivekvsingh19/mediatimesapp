import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import 'news_provider.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.getCategories();
});
