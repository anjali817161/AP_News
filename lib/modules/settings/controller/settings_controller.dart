import 'package:get/get.dart';
import '../model/news_model.dart';

class SettingsController extends GetxController {
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
        title: 'App Settings Update Available',
        description: 'New features and improvements in the latest app settings update.',
        imageUrl: 'https://picsum.photos/300/200?random=201',
        category: 'Settings',
        timeAgo: '1h ago',
      ),
      News(
        title: 'Privacy Policy Changes',
        description: 'Important updates to our privacy policy and data handling practices.',
        imageUrl: 'https://picsum.photos/300/200?random=202',
        category: 'Privacy',
        timeAgo: '3h ago',
      ),
      News(
        title: 'Notification Preferences',
        description: 'Customize your notification settings for better user experience.',
        imageUrl: 'https://picsum.photos/300/200?random=203',
        category: 'Notifications',
        timeAgo: '5h ago',
      ),
      News(
        title: 'Account Security Tips',
        description: 'Best practices for keeping your account secure and protected.',
        imageUrl: 'https://picsum.photos/300/200?random=204',
        category: 'Security',
        timeAgo: '7h ago',
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
