import 'package:get/get.dart';
import '../../../services/news_service.dart';
import '../../read/model/news_model.dart';

class HomeController extends GetxController {
  final NewsService _newsService = NewsService();

  var newsList = <News>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialNews();
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

  void refreshNews() {
    fetchInitialNews();
  }
}
