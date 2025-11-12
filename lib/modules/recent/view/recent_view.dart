import 'package:ap_news/controllers/theme_controller.dart';
import 'package:ap_news/modules/bottom_navbar/bottom_navbar.dart';
import 'package:ap_news/modules/home/home_page.dart';
import 'package:ap_news/modules/news_details/model/news_details_model.dart';
import 'package:ap_news/modules/news_details/view/news_details.dart';
import 'package:ap_news/modules/sports/view/cricket_view.dart';
import 'package:ap_news/modules/trending/controller/trending_controller.dart';
import 'package:ap_news/modules/trending/view/trending_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../modules/recent/model/recentNews_model.dart'; // your News model

class RecentView extends StatefulWidget {
  const RecentView({super.key});

  @override
  State<RecentView> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentView> {
  final ScrollController _scrollController = ScrollController();
  late TrendingController controller;
  int _currentBottomNavIndex = 3;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TrendingController());

    // ✅ Detect scroll end to load more
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !controller.isLoadingMore.value &&
          controller.hasMoreData.value) {
        controller.loadMoreArticles();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TrendingPage()),
        );
        break;
      case 2:
        _showSearchDialog();
        break;
      case 3:
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CricketPage()),
        );
        break;
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Search News',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: const Text('Search functionality coming soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkTheme = themeController.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkTheme ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: const Text(
          'Read',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.newsList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.newsList.isEmpty) {
          return const Center(child: Text("No articles available."));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchArticles,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: controller.newsList.length + 1, // +1 for loader
            itemBuilder: (context, index) {
              if (index < controller.newsList.length) {
                final news = controller.newsList[index];
                return _buildNewsCard(news, controller);
              } else {
                // ✅ Bottom Loader
                if (controller.isLoadingMore.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (!controller.hasMoreData.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        "No more articles",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }
            },
          ),
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildNewsCard(News news, TrendingController controller) {
    final themeController = Provider.of<ThemeController>(context, listen: false);
    final isDarkTheme = themeController.isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkTheme ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: (news.imageUrl.isNotEmpty && news.imageUrl != 'null')
                    ? Image.network(
                        news.imageUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _fallbackLogo();
                        },
                      )
                    : _fallbackLogo(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[100]!),
                        ),
                        child: Text(
                          news.category,
                          style: TextStyle(
                            color: Colors.red[800],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        news.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme ? Colors.white : Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        news.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkTheme ? Colors.grey[300] : Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            news.timeAgo,
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                          const Spacer(),
                          TextButton(
  onPressed: () {
    // Convert News to NewsModel for details page
    final newsModel = NewsModel(
      id: news.articleId ?? news.title.hashCode.toString(),
      title: news.title,
      summary: news.description,
      content: news.content?.isNotEmpty == true
          ? news.content
          : news.description, // Prefer content, fallback to description
      image: news.imageUrl.isNotEmpty
          ? news.imageUrl
          : null, // Use featuredImage URL if available
      author: 'AP Desk',
      time: news.timeAgo,
      url: news.link,
      category: news.category,
      videoUrl: null, // Optionally handle video if you have one
    );

    // Open News Detail in article mode
    Get.to(
      () => const NewsDetailPage(),
      arguments: {
        'mode': 'article',
        'item': newsModel,
      },
    );
  },
  style: TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 4,
    ),
    backgroundColor: Colors.red[50],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
  ),
  child: Text(
    'Read More',
    style: TextStyle(
      color: Colors.red[800],
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
  ),
),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    news.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: news.isSaved ? Colors.red : Colors.white,
                    size: 20,
                  ),
                  onPressed: () => controller.toggleSave(news),
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white, size: 20),
                  onPressed: () => controller.shareNews(news),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackLogo() {
    return Container(
      width: 120,
      height: 120,
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/Ap-news_logo.png',
        width: 60,
        height: 60,
        fit: BoxFit.contain,
      ),
    );
  }
}
