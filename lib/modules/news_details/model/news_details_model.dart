// lib/modules/news_details/model/news_details_model.dart

class NewsModel {
  final String id;
  final String title;
  final String? summary;
  final String? content;
  final String? image;
  final String? imageAlt;
  final String? author;
  final String? time;
  final String? url;
  final String? category;
  final String? videoUrl;

  NewsModel({
    required this.id,
    required this.title,
    this.summary,
    this.content,
    this.image,
    this.imageAlt,
    this.author,
    this.time,
    this.url,
    this.category,
    this.videoUrl,
  });

  /// Factory for local map-based conversion
  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title']?.toString() ?? 'No Title',
      summary: map['summary']?.toString(),
      content: map['content']?.toString(),
      image: map['image']?.toString(),
      imageAlt: map['imageAlt']?.toString(),
      author: map['author']?.toString(),
      time: map['time']?.toString(),
      url: map['url']?.toString(),
      category: map['category']?.toString(),
      videoUrl: map['videoUrl']?.toString(),
    );
  }

  /// Factory to parse directly from API JSON (supports featuredImage object)
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final featuredImage = json['featuredImage'];
    String? imageUrl;
    String? imageAlt;

    if (featuredImage is Map<String, dynamic>) {
      imageUrl = featuredImage['url']?.toString();
      imageAlt = featuredImage['alt']?.toString();
    } else if (json['image'] != null) {
      imageUrl = json['image']?.toString();
    } else if (json['imageUrl'] != null) {
      imageUrl = json['imageUrl']?.toString();
    }

    return NewsModel(
      id: json['_id']?.toString() ??
          json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] is Map
          ? (json['title']['en'] ??
              json['title'].values.firstOrNull ??
              'No Title')
          : json['title']?.toString() ?? 'No Title',
      summary: json['summary'] is Map
          ? (json['summary']['en'] ??
              json['summary'].values.firstOrNull ??
              '')
          : json['summary']?.toString(),
      content: json['content'] is Map
          ? (json['content']['en'] ??
              json['content'].values.firstOrNull ??
              '')
          : json['content']?.toString(),
      image: imageUrl,
      imageAlt: imageAlt,
      author: json['author']?.toString() ?? 'AP Desk',
      time: json['publishAt']?.toString() ?? json['createdAt']?.toString(),
      url: json['slug'] != null
          ? "https://ap-news-b.onrender.com/api/articles/${json['slug']}"
          : json['url']?.toString(),
      category: json['category'] is Map
          ? (json['category']['en'] ??
              json['category'].values.firstOrNull ??
              'General')
          : json['category']?.toString() ?? 'General',
      videoUrl: json['videoUrl']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'image': image,
      'imageAlt': imageAlt,
      'author': author,
      'time': time,
      'url': url,
      'category': category,
      'videoUrl': videoUrl,
    };
  }
}
