class News {
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String timeAgo;
  bool isSaved;

  News({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.timeAgo,
    this.isSaved = false,
  });
}
