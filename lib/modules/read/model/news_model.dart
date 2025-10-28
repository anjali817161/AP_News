class News {
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String timeAgo;
  final String? articleId;
  final String? link;
  final String? pubDate;
  bool isSaved;

  News({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.timeAgo,
    this.articleId,
    this.link,
    this.pubDate,
    this.isSaved = false,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      imageUrl: json['image_url'] ?? '',
      category: json['category']?.first ?? 'General',
      timeAgo: _formatTimeAgo(json['pubDate']),
      articleId: json['article_id'],
      link: json['link'],
      pubDate: json['pubDate'],
    );
  }

  static String _formatTimeAgo(String? pubDate) {
    if (pubDate == null) return 'Unknown';

    try {
      final publishedDate = DateTime.parse(pubDate);
      final now = DateTime.now();
      final difference = now.difference(publishedDate);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}
