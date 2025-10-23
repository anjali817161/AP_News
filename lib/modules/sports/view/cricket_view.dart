// lib/modules/home/cricket_page.dart
import 'package:ap_news/modules/sports/controller/cricket_controller.dart';
import 'package:ap_news/controllers/theme_controller.dart';
import 'package:ap_news/modules/news_details/view/news_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart'; // optional native share

class CricketPage extends StatelessWidget {
  const CricketPage({Key? key}) : super(key: key);

  Widget _buildHeroCard(
    Map<String, dynamic> item,
    Color primaryRed,
    bool isDarkTheme,
  ) {
    final title = (item['title'] ?? item['headline'] ?? 'Cricket Update')
        .toString();
    final summary = (item['summary'] ?? item['desc'] ?? item['short'] ?? '')
        .toString();
    final img =
        (item['image'] ?? item['img'] ?? item['thumb'] ?? item['poster'] ?? '')
            .toString();
    final views = (item['views'] ?? item['view'] ?? '').toString();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkTheme ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // left image (if available)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: img.isNotEmpty
                ? Image.network(
                    img,
                    width: 110,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: 110,
                        height: 70,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.sports_cricket,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  )
                : Container(
                    width: 110,
                    height: 70,
                    color: Colors.grey[200],
                    child: Icon(Icons.sports_cricket, color: Colors.grey[400]),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryRed.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Cricket',
                        style: TextStyle(
                          color: primaryRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (views.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye,
                            size: 14,
                            color: isDarkTheme
                                ? Colors.grey[300]
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            views,
                            style: TextStyle(
                              color: isDarkTheme
                                  ? Colors.grey[300]
                                  : Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                if (summary.isNotEmpty)
                  Text(
                    summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDarkTheme ? Colors.grey[300] : Colors.grey[700],
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    Map<String, dynamic> item,
    int index,
    CricketController c,
    Color primaryRed,
    bool isDarkTheme,
  ) {
    final title = (item['title'] ?? item['headline'] ?? 'Cricket Update')
        .toString();
    final summary = (item['summary'] ?? item['desc'] ?? '').toString();
    final img = (item['image'] ?? item['img'] ?? item['thumb'] ?? '')
        .toString();
    final views = item['views']?.toString() ?? '';

    final id = (item['id'] ?? item['key'] ?? title.hashCode).toString();
    final isSaved = c.isSavedItem(id);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDarkTheme ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: img.isNotEmpty
                ? Image.network(
                    img,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        height: 180,
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.sports_cricket,
                          color: Colors.grey[400],
                          size: 48,
                        ),
                      );
                    },
                  )
                : Container(
                    height: 180,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.sports_cricket,
                      color: Colors.grey[400],
                      size: 48,
                    ),
                  ),
          ),

          // content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  summary,
                  style: TextStyle(
                    color: isDarkTheme ? Colors.grey[300] : Colors.grey[700],
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    if (views.isNotEmpty) ...[
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: isDarkTheme
                            ? Colors.grey[300]
                            : Colors.grey[500],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        views,
                        style: TextStyle(
                          color: isDarkTheme
                              ? Colors.grey[300]
                              : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                    ] else
                      const Spacer(),

                    // Save / Share / Read More
                    IconButton(
                      onPressed: () {
                        c.toggleSave(item);
                      },
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_outline,
                      ),
                      color: isSaved
                          ? primaryRed
                          : (isDarkTheme ? Colors.grey[300] : Colors.grey[700]),
                      tooltip: isSaved ? 'Saved' : 'Save',
                    ),

                    IconButton(
                      onPressed: () async {
                        final shareText = (item['url'] ?? item['link'] ?? title)
                            .toString();
                        // If you added share_plus, you can use Share.share(shareText);
                        await Clipboard.setData(ClipboardData(text: shareText));
                        Get.snackbar(
                          'Share',
                          'Copied to clipboard',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 1),
                        );
                      },
                      icon: const Icon(Icons.share_outlined),
                      color: isDarkTheme ? Colors.grey[300] : Colors.grey[700],
                      tooltip: 'Share',
                    ),

                    TextButton(
                      onPressed: () {
                        // Navigate to NewsDetailPage
                        Get.to(
                          () => const NewsDetailPage(),
                          arguments: {'mode': 'article', 'item': item},
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CricketController c = Get.put(CricketController());
    final primaryRed = Colors.red[800]!;
    final themeController = Provider.of<ThemeController>(context);
    final _isDarkTheme = themeController.isDarkMode;

    return Scaffold(
      backgroundColor: _isDarkTheme ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: primaryRed,
        title: const Text('Cricket'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.error.value.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: () => c.fetchCricketNews(forceRefresh: true),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Text(c.error.value, textAlign: TextAlign.center),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => c.fetchCricketNews(forceRefresh: true),
                    child: const Text('Retry'),
                  ),
                ),
              ],
            ),
          );
        }

        final items = c.items;
        if (items.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => c.fetchCricketNews(forceRefresh: true),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 140),
                Center(child: Text('No cricket items found')),
              ],
            ),
          );
        }

        // show top hero card + feed
        final heroItem = items.isNotEmpty ? items.first : <String, dynamic>{};

        return RefreshIndicator(
          onRefresh: () => c.fetchCricketNews(forceRefresh: true),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildHeroCard(heroItem, primaryRed, _isDarkTheme),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8,
                      ),
                      child: Text(
                        'Latest Cricket News',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _isDarkTheme ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _buildListItem(
                      context,
                      items[index],
                      index,
                      c,
                      primaryRed,
                      _isDarkTheme,
                    );
                  }, childCount: items.length),
                ),
              ),

              SliverToBoxAdapter(child: const SizedBox(height: 30)),
            ],
          ),
        );
      }),
    );
  }
}
