// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/video.dart';
// import 'news_provider.dart';

// class VideosNotifier extends StateNotifier<AsyncValue<List<Video>>> {
//   final ApiService apiService;
//   int _page = 1;
//   bool _hasMore = true;
//   List<Video> _videos = [];

//   VideosNotifier(this.apiService) : super(const AsyncValue.loading()) {
//     fetchVideos();
//   }

//   Future<void> fetchVideos({bool refresh = false}) async {
//     if (refresh) {
//       _page = 1;
//       _hasMore = true;
//       _videos = [];
//       state = const AsyncValue.loading();
//     }

//     if (!_hasMore && !refresh) return;

//     try {
//       final newVideos = await apiService.getVideos(page: _page);
//       if (newVideos.isEmpty) {
//         _hasMore = false;
//       } else {
//         _page++;
//         _videos.addAll(newVideos);
//       }
//       state = AsyncValue.data(List.from(_videos));
//     } catch (e, st) {
//       if (_videos.isEmpty) {
//         state = AsyncValue.error(e, st);
//       }
//     }
//   }
// }

// final videosProvider = StateNotifierProvider<VideosNotifier, AsyncValue<List<Video>>>((ref) {
//   return VideosNotifier(ref.read(apiServiceProvider));
// });
