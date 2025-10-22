import 'package:get/get.dart';
import '../model/news_model.dart';

class LearningController extends GetxController {
  var newsList = <News>[].obs;
  var savedNews = <News>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyNews();
  }

  void loadDummyNews() {
    newsList.assignAll([
      News(
        title: 'New Educational Technology Revolution',
        description: 'Learn about the latest advancements in educational technology that are transforming classrooms worldwide.',
        imageUrl: 'https://picsum.photos/300/200?random=101',
        category: 'Technology',
        timeAgo: '2h ago',
      ),
      News(
        title: 'Online Learning Platforms Growth',
        description: 'The rise of online learning platforms and their impact on traditional education systems.',
        imageUrl: 'https://picsum.photos/300/200?random=102',
        category: 'Education',
        timeAgo: '4h ago',
      ),
      News(
        title: 'STEM Education Initiatives',
        description: 'Government initiatives to promote STEM education among young students.',
        imageUrl: 'https://picsum.photos/300/200?random=103',
        category: 'Science',
        timeAgo: '6h ago',
      ),
      News(
        title: 'Digital Literacy Programs',
        description: 'New programs aimed at improving digital literacy skills across all age groups.',
        imageUrl: 'https://picsum.photos/300/200?random=104',
        category: 'Technology',
        timeAgo: '8h ago',
      ),
    ]);
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
