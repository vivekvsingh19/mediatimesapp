// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../providers/videos_provider.dart';

// class VideosScreen extends ConsumerWidget {
//   const VideosScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final videosState = ref.watch(videosProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('VIDEOS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
//         centerTitle: true,
//       ),
//       body: videosState.when(
//         data: (videos) {
//           if (videos.isEmpty) {
//             return const Center(child: Text('No videos available.'));
//           }
//           return RefreshIndicator(
//             onRefresh: () => ref.read(videosProvider.notifier).fetchVideos(refresh: true),
//             child: ListView.separated(
//               itemCount: videos.length + 1,
//               separatorBuilder: (context, index) => const Divider(height: 32),
//               itemBuilder: (context, index) {
//                 if (index == videos.length) {
//                   return const Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Center(child: CircularProgressIndicator()),
//                   );
//                 }
//                 final video = videos[index];
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       GestureDetector(
//                         onTap: () async {
//                            final url = Uri.parse(video.url);
//                            if (await canLaunchUrl(url)) {
//                              await launchUrl(url);
//                            }
//                         },
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             if (video.thumbnailUrl != null)
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: CachedNetworkImage(
//                                   imageUrl: video.thumbnailUrl!,
//                                   width: double.infinity,
//                                   height: 200,
//                                   fit: BoxFit.cover,
//                                   placeholder: (context, url) => Container(color: Colors.grey[200]),
//                                   errorWidget: (context, url, error) => Container(color: Colors.grey[200], child: const Icon(Icons.broken_image)),
//                                 ),
//                               )
//                             else
//                               Container(
//                                 width: double.infinity,
//                                 height: 200,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[800],
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                             Container(
//                               width: 60,
//                               height: 60,
//                               decoration: BoxDecoration(
//                                 color: Colors.black.withOpacity(0.6),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         video.title,
//                         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.3),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, stack) => Center(child: Text('Error: $err')),
//       ),
//     );
//   }
// }
