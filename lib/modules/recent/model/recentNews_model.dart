import '../../../services/api_endpoints.dart';

class News {
  final String title;
  final String description;
  final String content;
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
    required this.content,
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
      content: json['content'] ?? json['description'] ?? 'No Content',
      imageUrl: json['featuredImage']?['url'] ?? json['image_url'] ?? '',
      category: json['category'] is List
          ? json['category'].first
          : json['category'] ?? 'General',
      timeAgo: _formatTimeAgo(json['pubDate']),
      articleId: json['article_id'],
      link: json['link'],
      pubDate: json['pubDate'],
    );
  }

  factory News.fromArticleJson(Map<String, dynamic> json, String language) {
    final title = json['title'] is Map
        ? json['title'][language] ?? json['title']['en'] ?? 'No Title'
        : json['title']?.toString() ?? 'No Title';

    final summary = json['summary'] is Map
        ? json['summary'][language] ??
            json['summary']['en'] ??
            'No Description'
        : json['summary']?.toString() ?? 'No Description';

    final content = json['content'] is Map
        ? json['content'][language] ??
            json['content']['en'] ??
            summary
        : json['content']?.toString() ?? summary;

    final category = json['category'] is Map
        ? json['category'][language] ??
            json['category']['en'] ??
            'General'
        : json['category']?.toString() ?? 'General';

    final imageUrl = json['featuredImage'] is Map
        ? json['featuredImage']['url'] ??
            json['image']?.toString() ??
            json['imageUrl']?.toString() ??
            ''
        : json['featuredImage']?.toString() ??
            json['image']?.toString() ??
            json['imageUrl']?.toString() ??
            '';

    final slug = json['slug'] is Map
        ? json['slug'][language] ?? json['slug']['en']
        : json['slug']?.toString();

    final publishAt = json['publishAt'] is Map
        ? json['publishAt'][language] ?? json['publishAt']['en']
        : json['publishAt']?.toString();

    final createdAt = json['createdAt'] is Map
        ? json['createdAt'][language] ?? json['createdAt']['en']
        : json['createdAt']?.toString();

    return News(
      title: title,
      description: summary,
      content: content,
      imageUrl: imageUrl,
      category: category,
      timeAgo: _formatTimeAgo(publishAt ?? createdAt),
      articleId: json['_id']?.toString(),
      link: slug != null ? '${ApiEndpoints.baseUrl}articles/$slug' : null,
      pubDate: publishAt ?? createdAt,
    );
  }

  static String _formatTimeAgo(String? dateString) {
    if (dateString == null) return 'Unknown';

    try {
      final publishedDate = DateTime.parse(dateString);
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
