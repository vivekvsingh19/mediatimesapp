import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ad.dart';
import 'news_provider.dart'; // to get apiServiceProvider

final adsProvider = FutureProvider<List<AdModel>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getAds();
});
