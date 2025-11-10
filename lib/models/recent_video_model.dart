class RecentVideo {
  final String id;
  final String title;
  final String? summary;
  final String? image;
  final String url;
  final String? category;
  final String? time;
  final String? channelTitle;
  final bool isLive;

  RecentVideo({
    required this.id,
    required this.title,
    this.summary,
    this.image,
    required this.url,
    this.category,
    this.time,
    this.channelTitle,
    this.isLive = false,
  });

  factory RecentVideo.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final thumbnails = snippet['thumbnails'];
    final highThumbnail = thumbnails['high'] ?? thumbnails['medium'] ?? thumbnails['default'];

    return RecentVideo(
      id: json['id']['videoId'],
      title: snippet['title'],
      summary: snippet['description'],
      image: highThumbnail['url'],
      url: 'https://youtu.be/${json['id']['videoId']}',
      category: 'News',
      time: snippet['publishTime'] ?? 'Recent',
      channelTitle: snippet['channelTitle'],
    );
  }
}
