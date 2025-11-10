# TODO: Implement Live YouTube Videos in Home Page Slider

## Tasks
- [x] Create LiveVideo model (`lib/models/live_video_model.dart`)
- [x] Extend NewsService to fetch live videos (`lib/services/news_service.dart`)
- [x] Update HomeController to fetch and manage live videos (`lib/modules/home/controller/home_controller.dart`)
- [x] Modify HomePage carousel to use live videos with conditional sliding (`lib/modules/home/home_page.dart`)
- [x] Test the implementation and handle edge cases
- [x] Update trending page navigation to NewsDetailPage to include articleId in arguments for fetching full article details, ensuring proper data retrieval. Hit API on "Read More" button to fetch news details while keeping language and theme.
