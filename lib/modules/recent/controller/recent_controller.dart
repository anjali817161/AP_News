import 'package:get/get.dart';
import '../model/recentNews_model.dart';

class RecentController extends GetxController {
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
        title: 'The Future of Reading: Digital vs Print',
        description:
            'Exploring the ongoing debate between digital reading devices and traditional print books.',
        imageUrl: 'https://picsum.photos/300/200?random=401',
        category: 'Literature',
        timeAgo: '1h ago', content: 'hgfdfjhf',
      ),
      News(
        title: 'Bestselling Books of 2024',
        description:
            'A comprehensive look at the most popular books that captured readers\' attention this year.',
        imageUrl: 'https://picsum.photos/300/200?random=402',
        category: 'Bestsellers',
        timeAgo: '3h ago', content: 'wqdxqwhfdg kdgl  ',
      ),
      News(
        title: 'Audiobooks Revolution',
        description:
            'How audiobooks are changing the way people consume literature and stories.',
        imageUrl: 'https://picsum.photos/300/200?random=403',
        category: 'Technology',
        timeAgo: '5h ago', content: 'wqgiqgfiqofio',
      ),
      News(
        title: 'Classic Literature Adaptations',
        description:
            'Modern film and TV adaptations of timeless literary works.',
        imageUrl: 'https://picsum.photos/300/200?random=404',
        category: 'Adaptations',
        timeAgo: '7h ago', content: 'kdjwqidqwfioqhiofhqoihfoih',
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
    Get.snackbar(
      'Share',
      'Sharing: ${news.title}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
