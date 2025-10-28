import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../modules/read/model/news_model.dart';
import 'api_endpoints.dart';

class NewsService {
  static const int pageSize = 15;

  Future<List<News>> fetchLatestNews() async {
    try {
      // Get current language from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final language = prefs.getString('language') ?? 'en';

      // Map language codes to NewsData.io language codes
      final languageMap = {'en': 'en', 'hi': 'hi'};

      final langParam = languageMap[language] ?? 'en';

      final url = Uri.parse(
        '${ApiEndpoints.newsDataApi}?apikey=${ApiEndpoints.newsApiKey}&q=${ApiEndpoints.newsQuery}&language=$langParam',
      );

      print('[DEBUG] Fetching news from URL: $url');

      final response = await http.get(url);

      print('[DEBUG] Response status code: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>;

        print('[DEBUG] Number of results: ${results.length}');

        return results.map((item) {
          print('[DEBUG] Processing item: ${item['title']}');
          return News(
            title: item['title'] ?? 'No Title',
            description: item['description'] ?? 'No Description',
            imageUrl: item['image_url'] ?? '',
            category: item['category']?.first ?? 'General',
            timeAgo: _formatTimeAgo(item['pubDate']),
            articleId: item['article_id'],
            link: item['link'],
            pubDate: item['pubDate'],
          );
        }).toList();
      } else {
        throw Exception(
          'Failed to load news: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('[DEBUG] Exception caught: $e');
      throw Exception('Error fetching news: $e');
    }
  }

  String _formatTimeAgo(String? pubDate) {
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
