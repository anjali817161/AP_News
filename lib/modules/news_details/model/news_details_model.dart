// lib/modules/news_details/model/news_details_model.dart
class NewsModel {
  final String id;
  final String title;
  final String? summary;
  final String? content;
  final String? image;
  final String? author;
  final String? time;
  final String? url;
  final String? category; // <-- Add this
  final String? videoUrl; // <-- For video news

  NewsModel({
    required this.id,
    required this.title,
    this.summary,
    this.content,
    this.image,
    this.author,
    this.time,
    this.url,
    this.category,
    this.videoUrl,
  });

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id:
          map['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'] ?? '',
      summary: map['summary'],
      content: map['content'],
      image: map['image'],
      author: map['author'],
      time: map['time'],
      url: map['url'],
      category: map['category'], // <-- Add this mapping
      videoUrl: map['videoUrl'], // <-- Add this mapping
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'image': image,
      'author': author,
      'time': time,
      'url': url,
      'category': category,
      'videoUrl': videoUrl,
    };
  }
}
