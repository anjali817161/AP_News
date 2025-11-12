import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../modules/recent/model/recentNews_model.dart';
import '../models/live_video_model.dart';
import '../models/full_article_model.dart';
import '../models/recent_video_model.dart';
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
            pubDate: item['pubDate'], content: item['content'] ?? 'No content ',
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

  Future<List<LiveVideo>> fetchLiveVideos({String? language}) async {
    try {
      final lang = language ?? 'en';
      final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.liveVideos}?lang=$lang');

      print('[DEBUG] Fetching live videos from URL: $url');

      final response = await http.get(url);

      print('[DEBUG] Response status code: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final videoData = data['video'];
        if (videoData != null && videoData['items'] != null) {
          final results = videoData['items'] as List<dynamic>;

          print('[DEBUG] Number of live videos: ${results.length}');

          return results.map((item) {
            print('[DEBUG] Processing live video: ${item['snippet']['title']}');
            return LiveVideo.fromMap(item);
          }).toList();
        } else {
          print('[DEBUG] No videos found in response');
          return [];
        }
      } else {
        throw Exception(
          'Failed to load live videos: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('[DEBUG] Exception caught: $e');
      throw Exception('Error fetching live videos: $e');
    }
  }

  Future<List<News>> fetchArticles({int page = 1, int limit = 10}) async {
    try {
      // Get current language from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final language = prefs.getString('language') ?? 'en';

      final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.articlesAll}?page=$page&limit=$limit');

      print('[DEBUG] Fetching articles from URL: $url');

      final response = await http.get(url);

      print('[DEBUG] Response status code: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final items = data['items'] as List<dynamic>;

          print('[DEBUG] Number of articles: ${items.length}');

          return items.map((item) {
            print('[DEBUG] Processing article: ${item['title']}');
            return News.fromArticleJson(item, language);
          }).toList();
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception(
          'Failed to load articles: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('[DEBUG] Exception caught: $e');
      throw Exception('Error fetching articles: $e');
    }
  }

  Future<FullArticleModel> fetchFullArticle(String articleId) async {
    try {
      final url = Uri.parse('${ApiEndpoints.baseUrl}articles/$articleId');

      print('[DEBUG] Fetching full article from URL: $url');

      final response = await http.get(url);

      print('[DEBUG] Response status code: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return FullArticleModel.fromJson(data);
      } else {
        throw Exception(
          'Failed to load article: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('[DEBUG] Exception caught: $e');
      throw Exception('Error fetching full article: $e');
    }
  }

  Future<List<RecentVideo>> fetchRecentVideos() async {
    try {
      final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.recentVideos}');

      print('[DEBUG] Fetching recent videos from URL: $url');

      final response = await http.get(url);

      print('[DEBUG] Response status code: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List<dynamic>;

        print('[DEBUG] Number of recent videos: ${items.length}');

        return items.map((item) {
          print('[DEBUG] Processing recent video: ${item['snippet']['title']}');
          return RecentVideo.fromJson(item);
        }).toList();
      } else {
        throw Exception(
          'Failed to load recent videos: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('[DEBUG] Exception caught: $e');
      throw Exception('Error fetching recent videos: $e');
    }
  }

  Future<List<News>> fetchNewsByCategory(String category) async {
    try {
      // Get current language from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final language = prefs.getString('language') ?? 'en';

      // Map category to endpoint
      String endpoint;
      switch (category.toLowerCase()) {
        case 'business':
          endpoint = ApiEndpoints.businessCategory;
          break;
        case 'bhojpuri':
          endpoint = ApiEndpoints.bhojpuriCategory;
          break;
        case 'technology':
          endpoint = ApiEndpoints.technologyCategory;
          break;
        case 'elections':
          endpoint = ApiEndpoints.electionsCategory;
          break;
        case 'sports':
          endpoint = ApiEndpoints.sportsCategory;
          break;
        default:
          // Default to business if category not found
          endpoint = ApiEndpoints.businessCategory;
      }

      final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');

      print('[DEBUG] Fetching category news from URL: $url');

      final response = await http.get(url);

      print('[DEBUG] Response status code: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final items = data['articles'] as List<dynamic>;

          print('[DEBUG] Number of category articles: ${items.length}');

          return items.map((item) {
            print('[DEBUG] Processing category article: ${item['title']}');
            return News.fromArticleJson(item, language);
          }).toList();
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception(
          'Failed to load category news: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('[DEBUG] Exception caught: $e');
      throw Exception('Error fetching category news: $e');
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
