// lib/modules/home/cricket_page.dart
import 'package:ap_news/modules/sports/controller/cricket_controller.dart';
import 'package:ap_news/controllers/theme_controller.dart';
import 'package:ap_news/modules/news_details/view/news_details.dart';
import 'package:ap_news/modules/sports/view/Cicketdetail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CricketPage extends StatelessWidget {
  const CricketPage({Key? key}) : super(key: key);

  Widget _buildHeroCard(
    Map<String, dynamic> item,
    Color primaryRed,
    bool isDarkTheme,
  ) {
    final team1 = (item['t_one'] ?? 'Team 1').toString();
    final team2 = (item['t_two'] ?? 'Team 2').toString();
    final series = (item['series'] ?? '').toString();
    final status = (item['status'] ?? 'COMPLETED').toString();
    final score1 = (item['t_one_s'] ?? '').toString();
    final score2 = (item['t_two_s'] ?? '').toString();
    final matchStatus = (item['m_status'] ?? '').toString();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Series and Status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              if (status == 'LIVE')
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Teams and Scores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team1,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (score1.isNotEmpty)
                      Text(
                        score1,
                        style: TextStyle(
                          fontSize: 14,
                          color: primaryRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                'vs',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkTheme ? Colors.grey[300] : Colors.grey[600],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      team2,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (score2.isNotEmpty)
                      Text(
                        score2,
                        style: TextStyle(
                          fontSize: 14,
                          color: primaryRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Match Status
          if (matchStatus.isNotEmpty)
            Text(
              matchStatus,
              style: TextStyle(
                fontSize: 12,
                color: isDarkTheme ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
          // Series
          if (series.isNotEmpty)
            Text(
              series,
              style: TextStyle(
                fontSize: 12,
                color: isDarkTheme ? Colors.grey[400] : Colors.grey[500],
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
    final team1 = (item['t_one'] ?? 'Team 1').toString();
    final team2 = (item['t_two'] ?? 'Team 2').toString();
    final series = (item['series'] ?? '').toString();
    final status = (item['status'] ?? 'COMPLETED').toString();
    final score1 = (item['t_one_s'] ?? '').toString();
    final score2 = (item['t_two_s'] ?? '').toString();
    final matchStatus = (item['m_status'] ?? '').toString();
    final url = (item['url'] ?? '').toString();

    final id = (item['id'] ?? item['url'] ?? '$team1 vs $team2'.hashCode)
        .toString();
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
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Series and Status
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
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (status == 'LIVE')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Teams and Scores
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team1,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (score1.isNotEmpty)
                        Text(
                          score1,
                          style: TextStyle(
                            fontSize: 14,
                            color: primaryRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  'vs',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkTheme ? Colors.grey[300] : Colors.grey[600],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        team2,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (score2.isNotEmpty)
                        Text(
                          score2,
                          style: TextStyle(
                            fontSize: 14,
                            color: primaryRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Match Status
            if (matchStatus.isNotEmpty)
              Text(
                matchStatus,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkTheme ? Colors.grey[300] : Colors.grey[600],
                ),
              ),
            // Series
            if (series.isNotEmpty)
              Text(
                series,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkTheme ? Colors.grey[400] : Colors.grey[500],
                ),
              ),
            const SizedBox(height: 10),
            // Actions
            Row(
              children: [
                const Spacer(),
                // Save
                IconButton(
                  onPressed: () {
                    c.toggleSave(item);
                  },
                  icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_outline),
                  color: isSaved
                      ? primaryRed
                      : (isDarkTheme ? Colors.grey[300] : Colors.grey[700]),
                  tooltip: isSaved ? 'Saved' : 'Save',
                ),
                // Share
                IconButton(
                  onPressed: () async {
                    final shareText = url.isNotEmpty
                        ? 'https://crictimes.org/score/$url'
                        : '$team1 vs $team2';
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
                // View Details
               // Inside Row(children: [...])
// TextButton(
//   onPressed: () {
//     final query = '$team1 vs $team2';
//     final matchUrl = 'https://www.google.com/search?q=${Uri.encodeComponent(query)}';
//   //   Get.to(() => CricketDetailsPage(
//   //     matchUrl: matchUrl,
//   //     title: query,
//   //   ));
//   // },
//   style: TextButton.styleFrom(
//     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//     backgroundColor: Colors.red[50],
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//   ),
//   child: Text(
//     'View Details',
//     style: TextStyle(
//       color: Colors.red[800],
//       fontSize: 12,
//       fontWeight: FontWeight.bold,
//     ),
//   ),
// ),

              ],
            ),
          ],
        ),
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
        title: const Text(
          'Cricket News',
          style: TextStyle(color: Colors.white),
        ),
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
