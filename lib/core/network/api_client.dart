import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import '../constants/api_constants.dart';

class ApiClient {
  final Dio dio;
  CacheOptions? cacheOptions;

  ApiClient({CacheStore? cacheStore})
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
      ) {
    if (cacheStore != null) {
      cacheOptions = CacheOptions(
        store: cacheStore,
        policy: CachePolicy.request, // Always fetch fresh, fallback to cache on error
        hitCacheOnErrorExcept: [401, 403],
        maxStale: const Duration(hours: 4), // Cache for 4 hours
        priority: CachePriority.normal,
        cipher: null,
        keyBuilder: CacheOptions.defaultCacheKeyBuilder,
        allowPostMethod: false,
      );
      dio.interceptors.add(DioCacheInterceptor(options: cacheOptions!));
    }
    
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: false,
      logPrint: (obj) => print(obj.toString()),
    ));
  }
}
