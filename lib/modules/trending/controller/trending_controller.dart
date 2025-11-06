import 'package:get/get.dart';
import '../../../services/news_service.dart';
import '../../recent/model/recentNews_model.dart';

class TrendingController extends GetxController {
  final NewsService _newsService = NewsService();

  var newsList = <News>[].obs;
  var savedNews = <News>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      isLoading.value = true;
      final articles = await _newsService.fetchArticles();
      newsList.assignAll(articles);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load articles: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreArticles() async {
    if (isLoadingMore.value || !hasMoreData.value) return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;
      final moreArticles = await _newsService.fetchArticles(page: currentPage.value);
      if (moreArticles.isEmpty) {
        hasMoreData.value = false;
      } else {
        newsList.addAll(moreArticles);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load more articles: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  void toggleSave(News news) {
    news.isSaved = !news.isSaved;
    if (news.isSaved) {
      savedNews.add(news);
    } else {
      savedNews.remove(news);
    }
    newsList.refresh();
  }

  void shareNews(News news) {
    // Implement share functionality
    Get.snackbar(
      'Share',
      'Sharing: ${news.title}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
