class FullArticleModel {
  final String id;
  final Map<String, String> title;
  final Map<String, String> summary;
  final Map<String, String> content;
  final String? imageUrl;
  final String? author;
  final String? category;
  final String? publishAt;
  final int? views;
  final int? readingTimeMinutes;
  final String? youtubeVideoId;

  FullArticleModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    this.imageUrl,
    this.author,
    this.category,
    this.publishAt,
    this.views,
    this.readingTimeMinutes,
    this.youtubeVideoId,
  });

  factory FullArticleModel.fromJson(Map<String, dynamic> json) {
    return FullArticleModel(
      id: json['_id'] ?? '',
      title: Map<String, String>.from(json['title'] ?? {}),
      summary: Map<String, String>.from(json['summary'] ?? {}),
      content: Map<String, String>.from(json['content'] ?? {}),
      imageUrl: json['featuredImage']?['url'],
      author: json['author']?['name'],
      category: json['category'],
      publishAt: json['publishAt'],
      views: json['views'],
      readingTimeMinutes: json['readingTimeMinutes'],
      youtubeVideoId: json['youtubeVideoId'],
    );
  }

  String getTitle(String language) => title[language] ?? title['en'] ?? 'No Title';
  String getSummary(String language) => summary[language] ?? summary['en'] ?? 'No Summary';
  String getContent(String language) => content[language] ?? content['en'] ?? 'No Content';
}
