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
        policy: CachePolicy.forceCache, // Use cache if available to save server requests
        hitCacheOnErrorExcept: [401, 403],
        maxStale: const Duration(minutes: 10), // Cache remains valid for 10 minutes
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
