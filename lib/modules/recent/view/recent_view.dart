import 'package:ap_news/controllers/theme_controller.dart';
import 'package:ap_news/modules/bottom_navbar/bottom_navbar.dart';
import 'package:ap_news/modules/home/home_page.dart';
import 'package:ap_news/modules/news_details/view/news_details.dart';
import 'package:ap_news/modules/recent/controller/recent_controller.dart';
import 'package:ap_news/modules/recent/model/recentNews_model.dart';
import 'package:ap_news/modules/sports/view/cricket_view.dart';
import 'package:ap_news/modules/trending/view/trending_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RecentView extends StatefulWidget {
  const RecentView({super.key});

  @override
  State<RecentView> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentView> {
  int _currentBottomNavIndex = 3; // Read is index 3

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TrendingPage()),
        );
        break;
      case 2: // Search
        // Show search dialog or navigate to search page
        _showSearchDialog();
        break;
      case 3: // Read
        // Already on read page
        break;
      case 4: // Sports
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
          'Search Flight',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchField('From', Icons.flight_takeoff),
            const SizedBox(height: 10),
            _buildSearchField('To', Icons.flight_land),
            const SizedBox(height: 15),
            _buildFilterSection(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('Search'),
          ),
        ],
      ),
    );
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
    final RecentController controller = Get.put(RecentController());
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
        if (controller.newsList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.newsList.length,
          itemBuilder: (context, index) {
            final news = controller.newsList[index];
            return _buildNewsCard(news, controller);
          },
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildNewsCard(News news, RecentController controller) {
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
                child: Image.network(
                  news.imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
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
                              // Navigate to NewsDetailPage
                              Get.to(
                                () => const NewsDetailPage(),
                                arguments: {'mode': 'article', 'item': news},
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
