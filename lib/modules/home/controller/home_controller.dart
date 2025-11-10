import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/news_service.dart';
import '../../../models/live_video_model.dart';
import '../../../models/recent_video_model.dart';
import '../../recent/model/recentNews_model.dart';

class HomeController extends GetxController {
  final NewsService _newsService = NewsService();

  var newsList = <News>[].obs;
  var articlesList = <News>[].obs;
  var liveVideos = <LiveVideo>[].obs;
  var recentVideos = <RecentVideo>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;
  var isLoadingLiveVideos = false.obs;
  var liveVideosError = ''.obs;
  var isLoadingRecentVideos = false.obs;
  var recentVideosError = ''.obs;
  var isLoadingArticles = false.obs;
  var articlesError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialNews();
    fetchLiveVideos();
    fetchRecentVideos();
    fetchArticles();
  }

  Future<void> fetchInitialNews() async {
    try {
      isLoading.value = true;
      final news = await _newsService.fetchLatestNews();
      newsList.assignAll(news);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load news: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreNews() async {
    // Infinite scroll disabled - do nothing
    return;
  }

  void toggleSave(News news) {
    news.isSaved = !news.isSaved;
    newsList.refresh();
  }

  Future<void> fetchLiveVideos() async {
    try {
      isLoadingLiveVideos.value = true;
      liveVideosError.value = '';
      // Get current language from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final language = prefs.getString('language') ?? 'en';
      final videos = await _newsService.fetchLiveVideos(language: language);
      liveVideos.assignAll(videos);
    } catch (e) {
      liveVideosError.value = e.toString();
      print('[DEBUG] Live videos error: $e');
    } finally {
      isLoadingLiveVideos.value = false;
    }
  }

  Future<void> fetchRecentVideos() async {
    try {
      isLoadingRecentVideos.value = true;
      recentVideosError.value = '';
      final videos = await _newsService.fetchRecentVideos();
      recentVideos.assignAll(videos);
    } catch (e) {
      recentVideosError.value = e.toString();
      print('[DEBUG] Recent videos error: $e');
    } finally {
      isLoadingRecentVideos.value = false;
    }
  }

  Future<void> fetchArticles({int page = 1, int limit = 10}) async {
    try {
      isLoadingArticles.value = true;
      articlesError.value = '';
      final articles = await _newsService.fetchArticles(page: page, limit: limit);
      if (page == 1) {
        articlesList.assignAll(articles);
      } else {
        articlesList.addAll(articles);
      }
      currentPage.value = page;
      hasMoreData.value = articles.length == limit;
    } catch (e) {
      articlesError.value = e.toString();
      print('[DEBUG] Articles error: $e');
    } finally {
      isLoadingArticles.value = false;
    }
  }

  Future<void> loadMoreArticles() async {
    if (!hasMoreData.value || isLoadingArticles.value) return;
    await fetchArticles(page: currentPage.value + 1);
  }

  void refreshNews() {
    fetchInitialNews();
  }
}
