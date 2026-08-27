class Video {
  final String id;
  final String title;
  final String provider;
  final String? videoId;
  final String url;
  final String? thumbnailUrl;
  final String? createdAt;

  Video({
    required this.id,
    required this.title,
    required this.provider,
    this.videoId,
    required this.url,
    this.thumbnailUrl,
    this.createdAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as String,
      title: json['title'] as String,
      provider: json['provider'] as String,
      videoId: json['videoId'] as String?,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }
}
