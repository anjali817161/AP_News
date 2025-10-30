import 'package:get/get.dart';
import '../model/notifications_model.dart';

class NotificationsController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() {
    isLoading.value = true;
    // Simulate fetching notifications
    Future.delayed(const Duration(seconds: 1), () {
      notifications.value = [
        NotificationModel(
          id: '1',
          title: 'Breaking News: Major Policy Change',
          message:
              'The government has announced a new policy affecting millions of citizens.',
          time: '2 hours ago',
          isRead: false,
        ),
        NotificationModel(
          id: '2',
          title: 'Sports Update: Championship Finals',
          message:
              'The finals are scheduled for tomorrow. Don\'t miss the live coverage!',
          time: '4 hours ago',
          isRead: true,
        ),
        NotificationModel(
          id: '3',
          title: 'Weather Alert: Heavy Rain Expected',
          message:
              'Heavy rainfall expected in your area. Stay safe and indoors.',
          time: '6 hours ago',
          isRead: false,
        ),
        NotificationModel(
          id: '4',
          title: 'Tech News: New Gadget Launch',
          message:
              'A revolutionary new smartphone has been launched with cutting-edge features.',
          time: '1 day ago',
          isRead: true,
        ),
        NotificationModel(
          id: '5',
          title: 'Entertainment: Movie Release',
          message:
              'The highly anticipated movie is now in theaters. Book your tickets!',
          time: '2 days ago',
          isRead: false,
        ),
      ];
      isLoading.value = false;
    });
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = NotificationModel(
        id: notifications[index].id,
        title: notifications[index].title,
        message: notifications[index].message,
        time: notifications[index].time,
        isRead: true,
      );
      notifications.refresh();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      notifications[i] = NotificationModel(
        id: notifications[i].id,
        title: notifications[i].title,
        message: notifications[i].message,
        time: notifications[i].time,
        isRead: true,
      );
    }
    notifications.refresh();
  }
}
