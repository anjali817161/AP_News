// lib/modules/categories/view/categories_news.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart'; // for Clipboard
import 'package:provider/provider.dart';
import 'package:ap_news/modules/news_details/view/news_details.dart';
import 'package:ap_news/modules/news_details/model/news_details_model.dart';
import 'package:ap_news/modules/categories/controller/categories_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../modules/recent/model/recentNews_model.dart';

class CategoryNewsPage extends StatefulWidget {
  final String category;

  const CategoryNewsPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CategoryNewsPage> createState() => _CategoryNewsPageState();
}

class _CategoryNewsPageState extends State<CategoryNewsPage> {
  final CategoriesController _controller = Get.put(CategoriesController());

  @override
  void initState() {
    super.initState();
    // Fetch news for the category
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchNewsByCategory(widget.category);
    });
  }

  Future<void> _showShareOptions(News news) async {
    final url = news.link ?? '';
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Share',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.copy),
                  title: const Text('Copy Link'),
                  onTap: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text: url.isNotEmpty ? url : news.title,
                      ),
                    );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                ),
                // You can add other share integrations here (share_plus) if you want
                ListTile(
                  leading: const Icon(Icons.more_horiz),
                  title: const Text('More Options'),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Use native share integration (optional)',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  Widget _buildInfoCard(Color primaryRed, bool isDarkTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkTheme ? Colors.grey[850] : Colors.white,
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
          // top row: category pill + small metadata
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: primaryRed.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryRed.withOpacity(0.12)),
                ),
                child: Text(
                  widget.category,
                  style: TextStyle(
                    color: primaryRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.star, color: Colors.orange, size: 16),
              const SizedBox(width: 4),
              const Text('4.9', style: TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              Obx(() => Text(
                _controller.isLoading.value ? 'LOADING...' : 'ARTICLES',
                style: TextStyle(
                  color: primaryRed,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ],
          ),
          const SizedBox(height: 12),

          // Headline
          Text(
            '${widget.category} News',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkTheme ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // author / time / views
          Row(
            children: [
              Icon(
                Icons.person,
                size: 14,
                color: isDarkTheme ? Colors.grey[400] : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                'By AP Desk',
                style: TextStyle(
                  color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.schedule,
                size: 14,
                color: isDarkTheme ? Colors.grey[400] : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                'Updated daily',
                style: TextStyle(
                  color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.visibility,
                size: 14,
                color: isDarkTheme ? Colors.grey[400] : Colors.grey,
              ),
              const SizedBox(width: 6),
              Obx(() => Text(
                '${_controller.newsList.length} articles',
                style: TextStyle(
                  color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 13,
                ),
              )),
            ],
          ),
          const SizedBox(height: 12),

          // description
          Text(
            'Latest news and updates from the ${widget.category.toLowerCase()} category. Stay informed with breaking news and in-depth coverage.',
            style: TextStyle(
              color: isDarkTheme ? Colors.grey[300] : Colors.grey[800],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

Widget _buildFeedCard(
  News news,
  int index,
  Color primaryRed,
  bool isDarkTheme,
) {
  final isSaved = news.isSaved;

  // ✅ Safely handle image source
  final String imageToShow = (news.imageUrl.isNotEmpty)
      ? news.imageUrl
      : 'assets/images/Ap-news_logo.png'; // fallback image

  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    decoration: BoxDecoration(
      color: isDarkTheme ? Colors.grey[850] : Colors.white,
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
        // ✅ Image section with fallback
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: imageToShow.startsWith('http')
              ? Image.network(
                  imageToShow,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // fallback on network error too
                    return Image.asset(
                      'assets/images/Ap-news_logo.png',
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.contain,
                    );
                  },
                )
              : Image.asset(
                  imageToShow,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.contain,
                ),
        ),

        // ✅ Content section
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkTheme ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                news.description,
                style: TextStyle(
                  color: isDarkTheme ? Colors.grey[300] : Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: isDarkTheme ? Colors.grey[400] : Colors.grey[500],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    news.timeAgo,
                    style: TextStyle(
                      color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),

                  // ✅ Read More button
                  TextButton(
                    onPressed: () {
                      final newsModel = NewsModel(
                        id: news.articleId ?? news.title.hashCode.toString(),
                        title: news.title,
                        summary: news.description,
                        content: news.content,
                        image: news.imageUrl.isNotEmpty
                            ? news.imageUrl
                            : 'assets/images/Ap-news_logo.png', // fallback here too
                        author: 'AP Desk',
                        time: news.timeAgo,
                        url: news.link,
                        category: news.category,
                        videoUrl: null,
                      );

                      Get.to(
                        () => const NewsDetailPage(),
                        arguments: {
                          'mode': 'article',
                          'item': newsModel,
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      backgroundColor:
                          isDarkTheme ? Colors.grey[700] : Colors.red[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      'Read More',
                      style: TextStyle(
                        color: isDarkTheme ? Colors.white : Colors.red[800],
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
    final themeController = Provider.of<ThemeController>(context);
    final isDarkTheme = themeController.isDarkMode;
    final primaryRed = Colors.red[800]!;
    final lightBg = Colors.grey[50];
    final darkBg = Colors.grey[900]!;

    return Scaffold(
      backgroundColor: isDarkTheme ? darkBg : lightBg,
      body: SafeArea(
        bottom: true,
        child: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Info card
              SliverToBoxAdapter(
                child: _buildInfoCard(primaryRed, isDarkTheme),
              ),

              // Feed list
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final news = _controller.newsList[index];
                    return _buildFeedCard(news, index, primaryRed, isDarkTheme);
                  }, childCount: _controller.newsList.length),
                ),
              ),

              // bottom spacing
              SliverToBoxAdapter(child: const SizedBox(height: 30)),
            ],
          );
        }),
      ),
    );
  }
}
