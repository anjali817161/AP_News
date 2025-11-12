import 'package:ap_news/controllers/theme_controller.dart';
import 'package:ap_news/modules/bottom_navbar/bottom_navbar.dart';
import 'package:ap_news/modules/home/home_page.dart';
import 'package:ap_news/modules/news_details/view/news_details.dart';
import 'package:ap_news/modules/news_details/model/news_details_model.dart';
import 'package:ap_news/modules/recent/model/recentNews_model.dart';
import 'package:ap_news/modules/recent/view/recent_view.dart';
import 'package:ap_news/modules/sports/view/cricket_view.dart';
import 'package:ap_news/modules/trending/controller/trending_controller.dart';
import 'package:ap_news/services/news_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<TrendingPage> {
  final NewsService _newsService = NewsService();
  int _currentBottomNavIndex = 1; // Learning is index 1

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });
    // Handle navigation based on index
    switch (index) {
      case 0: // Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1: // Learning
        // Already on learning page
        break;
      case 2: // Search
        // Show search dialog or navigate to search page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TrendingPage()),
        );
        break;
      case 3: // Read
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RecentView()),
        );
        break;
      case 4: // Sports
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CricketPage()),
        );
        break;
    }
  }

  Widget _buildSearchField(String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.red),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Data Filter',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        _buildFilterOption('Default', true),
        _buildFilterOption('Status: True', false),
        _buildFilterOption('Error: False', false),
      ],
    );
  }

  Widget _buildFilterOption(String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.red[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSelected ? Colors.red! : Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected ? Colors.red : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.red : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TrendingController controller = Get.put(TrendingController());
    final themeController = Provider.of<ThemeController>(context);
    final isDarkTheme = themeController.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkTheme ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: const Text(
          'Learning',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.newsList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.newsList.isEmpty) {
          return const Center(child: Text('No articles available'));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!controller.isLoadingMore.value &&
                scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              controller.loadMoreArticles();
            }
            return false;
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.newsList.length + (controller.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.newsList.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final news = controller.newsList[index];
              return _buildNewsCard(news, controller);
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
    final themeController = Provider.of<ThemeController>(
      context,
      listen: false,
    );
    final isDarkTheme = themeController.isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkTheme ? Colors.grey[800] : Colors.white,
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
            return Container(
              width: 120,
              height: 120,
              color: Colors.grey[200],
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/Ap-news_logo.png', // ✅ fallback logo
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
            );
          },
        )
      : Container(
          width: 120,
          height: 120,
          color: Colors.grey[200],
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/Ap-news_logo.png', // ✅ fallback logo
            width: 60,
            height: 60,
            fit: BoxFit.contain,
          ),
        ),
),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
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
                          color: isDarkTheme
                              ? Colors.grey[300]
                              : Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: isDarkTheme
                                ? Colors.grey[300]
                                : Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            news.timeAgo,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkTheme
                                  ? Colors.grey[300]
                                  : Colors.grey[500],
                            ),
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
                  icon: Icon(Icons.share, color: Colors.white, size: 20),
                  onPressed: () => controller.shareNews(news),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
