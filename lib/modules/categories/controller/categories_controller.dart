import 'package:get/get.dart';
import '../../../services/news_service.dart';
import '../../../modules/read/model/news_model.dart';

class CategoriesController extends GetxController {
  final NewsService _newsService = NewsService();

  var newsList = <News>[].obs;
  var isLoading = false.obs;
  var currentCategory = 'Home'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNewsByCategory('Home');
  }

  Future<void> fetchNewsByCategory(String category) async {
    try {
      isLoading.value = true;
      currentCategory.value = category;
      final news = await _newsService.fetchLatestNews();
      newsList.assignAll(news);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load news: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSave(News news) {
    news.isSaved = !news.isSaved;
    newsList.refresh();
  }
}
