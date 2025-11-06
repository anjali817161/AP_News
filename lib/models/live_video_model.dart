class LiveVideo {
  final String id;
  final String title;
  final String? summary;
  final String? image;
  final String url;
  final String? category;
  final String? time;
  final bool isLive;

  LiveVideo({
    required this.id,
    required this.title,
    this.summary,
    this.image,
    required this.url,
    this.category,
    this.time,
    this.isLive = false,
  });

  factory LiveVideo.fromMap(Map<String, dynamic> map) {
    final snippet = map['snippet'] ?? {};
    final idData = map['id'] ?? {};
    final thumbnails = snippet['thumbnails'] ?? {};
    final highThumb = thumbnails['high'] ?? thumbnails['medium'] ?? thumbnails['default'] ?? {};

    return LiveVideo(
      id: idData['videoId'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: snippet['title'] ?? 'Live Video',
      summary: snippet['description'],
      image: highThumb['url'],
      url: 'https://youtu.be/${idData['videoId'] ?? ''}',
      category: 'News',
      time: snippet['publishTime'] ?? 'Live',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'image': image,
      'url': url,
      'category': category,
      'time': time,
    };
  }
}
