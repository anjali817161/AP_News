import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../bottom_navbar/bottom_navbar.dart';
import '../../home/home_page.dart';
import '../../trending/view/trending_page.dart';
import '../../news_details/view/news_details.dart';
import '../../recent/view/recent_view.dart';
import '../../sports/view/cricket_view.dart';

import '../controller/settings_controller.dart';
import '../model/news_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentBottomNavIndex = 4; // Settings is index 4

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
    final SettingsController controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: const Text(
          'Settings',
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

  Widget _buildNewsCard(News news, SettingsController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: news.imageUrl.isNotEmpty && news.imageUrl != 'null'
              ? Image.network(
                  news.imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[600],
                        size: 40,
                      ),
                    );
                  },
                )
              : Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[600],
                    size: 40,
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    news.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        news.timeAgo,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
                      IconButton(
                        icon: Icon(
                          news.isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: news.isSaved ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                        onPressed: () => controller.toggleSave(news),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        onPressed: () => controller.shareNews(news),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
